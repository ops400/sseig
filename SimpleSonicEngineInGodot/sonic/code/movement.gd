extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer

var speed = 255
var gravity = 10
var jump = 25*gravity
#var moving = false
var velocity = Vector2()
#var right =  Vector2(1, 0)
#var left =  Vector2(-1, 0)
#var noDirection = Vector2(0, 0)
#var direction = noDirection
var UP = Vector2(0, -1)
var acceleration = 1

func _physics_process(delta):
	velocity.y += gravity
	if(Input.is_action_pressed("right")):
		velocity.x = min(velocity.x + acceleration, speed)
		animationPlayer.play("run2R")
	elif(Input.is_action_pressed("left")):
		velocity.x = max(velocity.x - acceleration, -speed)
		animationPlayer.play("run2L")
	else:
		velocity.x = lerp(velocity.x, 0, 0.09)
	if(Input.is_action_just_pressed("jump")):
		velocity.y -= jump
		animationPlayer.play("ballR")
	print(velocity.x)
	velocity = move_and_slide(velocity, UP)
