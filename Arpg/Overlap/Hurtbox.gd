extends Area2D


const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible  #创建无敌信号

onready var timer = $Timer    #向下调用
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):  #设定无敌帧的信号
	invincible = value       #赋予无敌一个值
	if invincible == true:   #这个值为true的时候就为无敌信号
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
	
func start_invincibility(duration): #无敌帧开始（计时器）
	self.invincible = true        #true为开始
	timer. start(duration)        #开始计时

func create_hit_effect():
	var effect = HitEffect.instance()#取场景节点
	var main = get_tree().current_scene #这里不实用parent因为会被free掉 
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout(): #无敌帧的时间信号设定
	self.invincible = false   # 计时结束            #这里必须加入self这样setter才能生效


func _on_Hurtbox_invincibility_started():#通过monitorable的开关设置来实现碰撞层的layer即不相撞等于无敌
	collisionShape.set_deferred("disabled", true) #需要用过set_deferred来使用monitorable它会在循环结束时候再设置
	
func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false
