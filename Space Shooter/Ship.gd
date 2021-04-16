extends Area2D

const ExplosionEffect = preload("res://ExplosionEffect.tscn")
const Laser = preload("res://Laser.tscn")

export var SPEED = 100

signal player_death

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= SPEED * delta
	if Input.is_action_pressed("ui_down"):
		position.y += SPEED * delta
	if Input.is_action_just_pressed("ui_accept"):
		fire_laser()

func fire_laser(): #建立函数与父体链接
	var laser = Laser.instance()  #使用场景通过instance
	var main = get_tree().current_scene #得到附体的场景节点
	main.add_child(laser) #使其添加成为父体的子节点
	laser.global_position = global_position  #位置等于飞船的位置

func _exit_tree():
	var main = get_tree().current_scene
	var explosionEffect = ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position = global_position
	emit_signal("player_death")

func _on_Ship_area_entered(area):
	area.queue_free()
	queue_free()
