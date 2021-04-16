extends KinematicBody2D #扩张/延伸
#const 为设置常/变量
const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500 #加速度 #使用export可以自由设定数值，变量出现在右边inspector窗口可以自由调整
export var MAX_SPEED = 80 #最大速度
export var ROLL_SPEED = 125 #翻滚速度
export var FRICTION = 500 #摩擦力

enum {                          
	MOVE,
	ROLL,
	ATTACK
}#enum为列举���型相当与一个常数集这里用来表示多个不同的状态，以便设置状态机
var state = MOVE
var velocity = Vector2.ZERO #var为宣言变量 这里指速度等于2d环境下的数学向量即变量速度为0
var roll_vector = Vector2.DOWN #宣言翻滚的方向，随着玩家方向变化而变化，这里的down应该是游戏开始时候的方向
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer #使用onrready var 这个变量即只会在这个节点初始化完成时被创建
							   #使用$可以获取节点的变量
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") #get为取这个变量取得之后才可以设置动画
onready var swordHitbox = $HitboxPivot/SwordHitbox #获取节点变量，需要用于设定knockback_vector等于我们的移动方向
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():      #设置此项后动画树就只在游戏开始时才会激活
	randomize() #让游戏每次运行都有不一样的结果
	stats.connect("no_health", self, "queue_free") #链接stats的信号
	animationTree.active = true #即active的开关，这里设置为true后面板处就需要off
	swordHitbox.knockback_vector = roll_vector #击退向量等于翻滚向量

func _physics_process(delta): #func为函数/関数
			#_process 的执行时间是在每次帧绘制完成后，可以使用 set_process() 来打开或者关闭，
			#只要写了这个函数，默认是打开执行的。
			#而 _physics_process 则是在物理引擎计算之前执行，而物理引擎的计算间隔是固定的，更新频率可以自行设定。
			#delta是每帧之间的秒数比如20帧就为1/20秒=0.05delta，乘以delta可以作为一种在不同帧数下会出现不同效果的解决方案
			#公式为变量乘以delita在乘以帧数，所以把变量乘以delta的话就可以解决以上问题。
	match state: #match相当于其他语言里的switch,主要区别数这些case可以是变量
	#状态机的核心就各个状态的代码分开进行处理与转换易于管理寻找bug等，这里使用match语句会决定哪一行代码被运行。
		MOVE:#这里直接引用创建好的move_state记得delta也要一起使用
			move_state(delta)

		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
			
func move_state(delta):
	
	var input_vector = Vector2.ZERO  #宣言输入速度等于2d环境下的数学向量
	input_vector.x =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#输入X轴（横轴）等于
	#get_action_strength为返回介于0和1之间的值，代表给定动作的强度。
	#例如，在游戏手柄中，轴（模拟摇杆或L2，R2触发器）离死区的距离越远，该值就越接近1。
	#如果将动作映射到没有轴作为控件的控件，键盘，返回的值为0或1。
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector . normalized() #将斜上斜下的速度限制在圆的半径内，即等于半径
	
	if input_vector != Vector2.ZERO: #如果的条件
		roll_vector = input_vector #翻滚距离等于输入方向
		swordHitbox.knockback_vector = input_vector #击退距离等于输入方向
		animationTree.set("parameters/Idle/blend_position", input_vector)#使用set来设定路径在节点可以查看，注意大小写。
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState. travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED,ACCELERATION * delta)
		## move toward的参数基本是固定的, 但是随着velocity的值不断增加
		# 第一次参数为1 x 100和 0.016 x 100, 步进1.6, 那么第一次得到的值就是1.667 
		# 第二次参数不变, 但是初始变了, 相当于从1.6667 到 100 , delta步进 1.6667,那么得到的值就为3.333
		# 这样就能保证了这个向量值(速度),是规律的不断增大
		# 这里有一个小知识点,就是move_toward的两个值(from和to)的差小于delta的时候,那么直接返回目的(to)的值
		# 比如 var tv3 = move_toward(50, 100, 51) # 得到100
		# 这样就使得这个函数再特定的时候可以有极限的值,也就是这里设定的最大速度
	else: #另外的条件，如果不满足if的条件就执行此条件
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
	
	move() #应用于整个move状态机的位移属性
	
	if Input.is_action_just_pressed("roll"):#按下按键
		state = ROLL
	
	if Input.is_action_just_pressed("attack"): #按下按键
		state = ATTACK

func roll_state(_delta): #翻滚状态机下的处理
	velocity = roll_vector * ROLL_SPEED  #翻滚速度的设定上面已经事先创建好变量
	animationState.travel("Roll")  #取翻滚状态机的动画
	move() #通过加入move属性实现位移

func move():
	velocity = move_and_slide(velocity)  #会在函数内部自动处理delta，靠近墙时保持速度不变

func attack_state(_delta): #攻击状态下的处理
	velocity = Vector2.ZERO #防止攻击位移
	animationState.travel("Attack") #取攻击的状态机的动画

func roll_animation_finished(): #动画播放完成后的状态
	velocity = Vector2.ZERO   #防止翻滚后出现滑动
	state = MOVE

func attack_animation_finished(): #动画播放完成后的状态
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)  #无敌时间
	hurtbox.create_hit_effect()
	var playerHurtSounds = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSounds)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
