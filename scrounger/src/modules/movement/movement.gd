extends CharacterBody3D

# How fast the player moves in meters per second.
@export var walking_speed = 15
# How fast the player moves in meters per second while running
@export var sprint_speed = 2
# How much the player jumps
@export var jump_strenght = 3500
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 400

signal direction_changed

var target_speed = 0

# Process user input
func get_input_direction():
	var direction = Vector3.ZERO
	var rs_look = Vector2.ZERO
	var speed = walking_speed
	
	rs_look.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	rs_look.y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	
	if rs_look != Vector2.ZERO:
		# Joystick specific controls
		direction.x = rs_look.x
		direction.z = rs_look.y
		speed *= rs_look.length() / sqrt(2)
	else:
		# Keyboard equivalents
		if Input.is_action_pressed("input_right"):
			direction.x += 1
		if Input.is_action_pressed("input_left"):
			direction.x -= 1
		if Input.is_action_pressed("input_back"):
			direction.z += 1
		if Input.is_action_pressed("input_forward"):
			direction.z -= 1
	
	if Input.is_action_pressed("run"):
		speed *= sprint_speed
	
	if(direction != Vector3.ZERO):
		$Pivot.basis = Basis.looking_at(direction)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		direction.y += 1
	
	
	# Normalize input vector
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
