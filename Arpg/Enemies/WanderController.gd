extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position #使用onready因为想获得它刚才被引用进来的位置
onready var target_position = global_position #小怪最后的位置

onready var timer = $Timer

func _ready():
	update_target_position() #使它一开始就可以移动

func update_target_position():   #它用我们的开始位置创建终点位置
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range)) #范围设定
	target_position = start_position + target_vector #这样目标就是永远对于开始的位置，不会跑到离开开始位置很远的地方
	
func get_time_left():  #这样就获得来timer剩余时间
		return timer.time_left
		
func start_wander_timer(duration):  #在这创建一个函数以便设置timer
	timer.start(duration)
	
func _on_Timer_timeout(): 
	update_target_position()

#所以我们的wandercontroller就是每当timer到时间时都创建一个新的目标向量
