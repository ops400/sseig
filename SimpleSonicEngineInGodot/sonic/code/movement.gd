extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

var speed = 500
var gravity = 10
var jump = 30*gravity
var velocity = Vector2()
var moving = false
var isJumping = false
var lookingUp = false
var pressingDown = false
var crouchFinish = false
var lookUpFinish = false
var right =  Vector2(1, 0)
var left =  Vector2(-1, 0)
var grounded1 = true
var grounded2 = true
var noDirection = Vector2(0, 0)
var direction = noDirection
var spriteOffSet = 21
var UP = Vector2(0, -1)
var animationRef
var animationReference = "idleR"
var acceleration = 1

func _physics_process(delta):
	velocity.y += gravity
	if(Input.is_action_pressed("right")):
		velocity.x = min(velocity.x + acceleration, speed)
		direction = right
	elif(Input.is_action_pressed("left")):
		velocity.x = max(velocity.x - acceleration, -speed)
		direction = left
	else:
		velocity.x = lerp(velocity.x, 0, 0.05)
	if(Input.is_action_just_pressed("jump") and is_on_floor() == true):
		velocity.y -= jump
		isJumping = true
	if(Input.is_action_pressed("up") and is_on_floor() == true):
		lookingUp = true
	else:
		lookingUp = false
		lookUpFinish = false
	if(Input.is_action_pressed("down") and is_on_floor() == true):
		pressingDown = true
	else:
		pressingDown = false
		crouchFinish = false
	if(velocity.x <= 4 and velocity.x >= -4 or is_zero_approx(velocity.x) == true):
		moving = false
	else:
		moving = true
	velocity.y = move_and_slide(velocity, UP).y
	animationset()
	directionForAnimationSet()
#	print(animationReference)
	animationPlay()

func animationset():
	if(isJumping == true and is_on_floor() == false):
		animationRef = "ball"
	elif(moving == true):
		if(velocity.x <= 100 or velocity.x >= -100):
			animationRef = "run1"
		if(velocity.x >= 100 and velocity.x <= 255 or velocity.x <= -100 and velocity.x >= -255):
			animationRef = "run2"
		if(velocity.x >= 255 and velocity.x <= 500 or velocity.x <= -255 and velocity.x >= -500):
			animationRef = "run3"
	elif(grounded1 == false):
		if(direction == right):
			animationRef = "balance1"
		if(direction == left):
			animationRef = "balance2"
	elif(grounded2 == false):
		if(direction == right):
			animationRef = "balance2"
		if(direction == left):
			animationRef = "balance1"
	elif(lookingUp == true and lookUpFinish == false):
		animationRef = "lookUp"
		lookUpFinish = true
	elif(lookUpFinish ==  true):
		animationRef = "lookUpSatay"
	elif(pressingDown == true and crouchFinish == false):
		animationRef = "crouch"
		crouchFinish = true
	elif(crouchFinish == true):
		animationRef = "crouchStay"
	else:
		animationRef = "idle"

func directionForAnimationSet():
	if(direction == right):
		animationReference = animationRef + "R"
		sprite.offset = Vector2(0, 0)
	if(direction == left):
		animationReference = animationRef + "L"
		sprite.offset = Vector2(spriteOffSet, 0)

func animationPlay():
	animationPlayer.play(animationReference)

func _on_groudDectection1_body_exited(body):
	grounded1 = false

func _on_groudDectection2_body_exited(body):
	grounded2 = false

func _on_groudDectection1_body_entered(body):
	grounded1 = true

func _on_groudDectection2_body_entered(body):
	grounded2 = true
