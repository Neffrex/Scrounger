@icon("res://assets/icons/keyboard.png")
extends Node

var paused = false

signal movement_input(direction: Vector3)
signal look_input(rotation_delta: Vector2)
signal jump_pressed()
signal pause()
signal unpause()

const MOUSE_SENSITIVITY := 0.002

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and not paused:
		emit_signal("look_input", event.relative * MOUSE_SENSITIVITY)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if paused else Input.MOUSE_MODE_VISIBLE)
			paused = !paused
			emit_signal("pause" if pause else "unpause")

func _process(_delta):
	var direction = Vector3.ZERO
	var is_sprinting = Input.is_action_pressed("sprint")
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_just_pressed("jump"):
		emit_signal("jump_pressed")
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	emit_signal("movement_input", direction, is_sprinting)
	
