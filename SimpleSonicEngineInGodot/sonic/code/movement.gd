extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

var speed = 500
var gravity = 10
var jump = 30*gravity
var velocity = Vector2()
var moving: bool = false
var isJumping: bool = false
var lookingUp: bool = false
var pressingDown: bool = false
var crouchFinish: bool = false
var lookUpFinish: bool = false
var right =  Vector2(1, 0)
var left =  Vector2(-1, 0)
var pushing: bool = false
var noDirection = Vector2(0, 0)
var direction = noDirection
var spriteOffSet = 21
var UP = Vector2(0, -1)
var animationRef
var animationReference = "idleR"
var acceleration = 2
var codeTimer = Timer.new()

func _physics_process(delta):
	velocity.y += gravity
	if(is_on_wall() == true and is_on_floor() == true):
		pushing = true
		velocity.x -= velocity.x
	else:
		pushing = false
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
	elif(isJumping == true and is_on_floor() == true):
		isJumping = false
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
#	var snap = transform.y * 128 if !isJumping else Vector2.ZERO
#	velocity = move_and_slide_with_snap(velocity.rotated(rotation), snap, -transform.y, false, 4, PI/3)
#	velocity = velocity.rotated(-rotation)
	velocity.y = move_and_slide(velocity, UP).y
	animationset()
	directionForAnimationSet()
#	print("g1: ",globalVars.sonicGroundedR)
#	print("g2: ",globalVars.sonicGroundedL)
	animationPlay()
	rotatePlayer()

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
	elif(globalVars.sonicGroundedR == false):
		if(direction == right):
			animationRef = "balance1"
		if(direction == left):
			animationRef = "balance2"
	elif(globalVars.sonicGroundedL == false):
		if(direction == right):
			animationRef = "balance2"
		if(direction == left):
			animationRef = "balance1"
	elif(lookingUp == true and lookUpFinish == false):
		animationRef = "lookUp"
		lookUpFinish = true
	elif(lookUpFinish ==  true):
		animationRef = "lookUpStay"
	elif(pressingDown == true and crouchFinish == false):
		animationRef = "crouch"
		crouchFinish = true
	elif(crouchFinish == true):
		animationRef = "crouchStay"
	elif(pushing == true):
		animationRef = "push"
	else:
		animationRef = "idle"

func directionForAnimationSet():
	if(direction == right):
		animationReference = animationRef + "R"
		sprite.offset = Vector2(0, 0)
	if(direction == left):
		animationReference = animationRef + "L"
		sprite.offset = Vector2(spriteOffSet, 0)

func rotatePlayer():
	if(is_on_floor()):
		var normal: Vector2 = get_floor_normal()
		var offset: float = deg2rad(90)
		rotation = normal.angle() + PI/2
	else:
		yield(get_tree().create_timer(1), "timeout")
		rotation = 0

func animationPlay():
	animationPlayer.play(animationReference)
