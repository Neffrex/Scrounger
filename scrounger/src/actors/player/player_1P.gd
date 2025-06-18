extends CharacterBody3D

@export var JUMP_VELOCITY = 4.5
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 9.0

@onready var head = $Head
@onready var input_mode = $KeyboardInput  # Podría también ser asignado dinámicamente

var _velocity = Vector3.ZERO
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	input_mode.connect("movement_input", _on_movement_input)
	input_mode.connect("look_input", _on_look_input)
	input_mode.connect("jump_pressed", _on_jump)

func _on_movement_input(direction, is_sprinting):
	var speed = SPRINT_SPEED if is_sprinting else WALK_SPEED
	var basis = global_transform.basis
	_velocity.x = (basis.x * direction.x + basis.z * direction.z).x * speed
	_velocity.z = (basis.x * direction.x + basis.z * direction.z).z * speed

func _on_look_input(delta: Vector2):
	rotate_y(-delta.x)
	head.rotate_x(-delta.y)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _on_jump():
	if is_on_floor():
		_velocity.y = JUMP_VELOCITY

func _physics_process(delta):
	if not is_on_floor():
		_velocity.y -= _gravity * delta
	velocity = _velocity
	move_and_slide()
