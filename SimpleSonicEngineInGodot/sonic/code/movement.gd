extends KinematicBody2D

var speed = 255
#var moving = false
var velocity = Vector2()
#var right =  Vector2(1, 0)
#var left =  Vector2(-1, 0)
#var noDirection = Vector2(0, 0)
#var direction = noDirection
var UP = Vector2(0, -1)
var acceleration = 1

func _physics_process(delta):
	if(Input.is_action_pressed("right")):
		velocity.x = min(velocity.x + acceleration, speed)
	elif(Input.is_action_pressed("left")):
		velocity.x = max(velocity.x - acceleration, -speed)
	else:
		velocity.x = lerp(velocity.x, 0, 0.09)
	print(velocity.x)
	velocity = move_and_slide(velocity, Vector2(0, 0))
