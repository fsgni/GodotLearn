extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300  #与玩家同样通过export易于管理调整
export var MAX_SPEED = 50  #速度
export var FRICTION = 200 #摩擦力
export var WANDER_TARGET_RANGE = 4 #游荡范围

enum{         #通过设置enemy的状态机来控制ai
	IDLE,   #空闲
	WANDER, #游荡
	CHASE   #追赶
}
var velocity = Vector2.ZERO #速度设定2d环境
var knockback = Vector2.ZERO  #击退攻击

var state = CHASE #设定原始状态

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox  #在这创建变量方便以后改名
onready var softCollision = $SoftCollision
onready var wanderControll = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():    #游戏开始时让他们随机选取一种状态
	state = pick_random_state([IDLE, WANDER]) 

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)#增加摩擦力
	knockback = move_and_slide(knockback)
	
	match state:                 #启用状态机，需要引用各种不同的函数
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
			
			if wanderControll.get_time_left() == 0:  #剩余时间为0时，重置timer
				update_wander()
			seek_player()
		WANDER:
			seek_player()
			if wanderControll.get_time_left() == 0:  #剩余时间为0时，重置timer
				update_wander()
			accelerate_towards_point(wanderControll.target_position, delta)
			if global_position.distance_to(wanderControll.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null :#如果范围内有玩家
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			

	if softCollision.is_colliding(): #软碰撞条件设定
		velocity += softCollision.get_push_vector() * delta * 400

	velocity = move_and_slide(velocity)

func accelerate_towards_point(point,delta):  
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0 #确保朝方向移动

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func update_wander():
	state = pick_random_state([IDLE, WANDER]) #加上中括号后就变味一个array（序列）
	wanderControll.start_wander_timer(rand_range(1, 3)) #从1 2 3中抽取一个值
		
func pick_random_state(state_list): #它会从我们提供的statelist种随机抽取一个state
	state_list.shuffle()
	return state_list.pop_front()#这里意思是对statelist进行洗牌，然后选取第一个就相当与随机抽一个

func _on_Hurtbox_area_entered(area):#用信号获取函数(受伤）
	stats.health -= area.damage       #swordhitbox的伤害值
	knockback = area.knockback_vector * 120 #设置距离的数值，然后让player新建hitbox的脚本宣言击退时玩家不位移
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)  #无敌时间

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()#这样就引用了我们的场景，因为想要使用Ysort
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position #effect与enemy位置同步


#保持良好的代码结构，向下调用，向上信号。这样可以保持各个对象的独立性
#那么当你给其他敌人添加stats时，比如一个有三阶段的boss，你这样设置的话，向上发送no health信号
#的时候，你就可以让他进入下一个阶段，而不是直接消失
#所以敌人场景可以用来决定当它没有生命值时要做什么


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
