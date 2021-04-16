extends Area2D

export var SPPED = 50
var moving  = false
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		move(SPPED, 0, delta)
		sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		move(-SPPED, 0, delta)
		sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		move(0, -SPPED, delta)
	if Input.is_action_pressed("ui_down"):
		move(0, SPPED, delta)
	
	if moving == true:
		animationPlayer.play("Run")
	else:
		animationPlayer.play("Idle")
		 
	
func move(xspeed,yspeed, delta):
	position.x += xspeed * delta
	position.y += yspeed * delta
	animationPlayer.play("Run")
	moving = true


func _on_Pig_area_entered(area):
	area.queue_free()
	scale *= 1.05
