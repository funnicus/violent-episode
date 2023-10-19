# This is a bit long to understand at first

# 3 types of player movements:

# type 0 --> 2d movement, left right jump
	# there are also more customizations for type 0 that has been commented out

# type 1 --> 2d plane free movement, a bit slide added (much more slide can be added as well)

# type 2 --> 2d plane free movement, no slide, stiff

# you can simply change the movement by changing the variable movement_type

extends CharacterBody2D
var camera: Camera2D

var movement_type = 1

# variables for movement type 0:
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var MAX_JUMP = 2

# variables for movement types 1 & 2
const MAX_SPEED = 150
const ACC = 2000 # No need in movement type 1
const FRICTION = 3700
var input = Vector2.ZERO

func _ready():
	camera = $Camera2D


func _physics_process(delta):
	
	if movement_type == 1:
		movement_1(delta)
		
	elif movement_type == 2:
		movement_2(delta)
	
	
	elif movement_type == 0:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			
			
		####################################################################################3

		# REGULAR JUMP
		#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#	velocity.y = JUMP_VELOCITY
		
		# DOUBLE JUMP
		#if is_on_floor() and jump_count!=0:
		#	jump_count=0
		
		#if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMP:
		#	velocity.y = JUMP_VELOCITY
		#	jump_count += 1
			
		# DOUBLE JUMP, BUT THE FIRST JUMP SHOULD BE ON FLOOR
		
		if is_on_floor() and jump_count!=0:
			jump_count=0
		
			# First jump
		if Input.is_action_just_pressed("ui_accept") and jump_count == 0 and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		
		if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMP and jump_count > 0 and not is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count += 1


		####################################################################################3
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()


# getter for both movements 1 and 2
func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func movement_1(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity = (input * MAX_SPEED)
		
		# Before (it was way more slippery with this):
		#velocity += (input * ACC * delta)
		#velocity = velocity.limit_length(MAX_SPEED)
		
	move_and_slide()
		


func movement_2(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = (input * MAX_SPEED)
		velocity = velocity.limit_length(MAX_SPEED)
		
	move_and_slide()
	

	
func _process(delta):

	camera.position.y = global_position.y - 350


