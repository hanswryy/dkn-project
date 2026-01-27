extends Camera2D

@export var speed: float = 500.0
@export var margin: float = 20.0 # Distance from edge in pixels
@export var min_boundary: Vector2 = Vector2(-100, -50)
@export var max_boundary: Vector2 = Vector2(100, 830)

func _ready() -> void:
	# Confines the mouse cursor to the game window
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _input(event: InputEvent) -> void:
	# It's good practice to allow the user to "unlock" the mouse
	if event.is_action_pressed("ui_cancel"): # Default is the 'Escape' key
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size
	var direction = Vector2.ZERO

	# Check Horizontal Edges
	if mouse_pos.x < margin:
		direction.x = -1
	elif mouse_pos.x > screen_size.x - margin:
		direction.x = 1

	# Check Vertical Edges
	if mouse_pos.y < margin:
		direction.y = -1
	elif mouse_pos.y > screen_size.y - margin:
		direction.y = 1

	# Inside _process, replace the last line with:
	var target_velocity = direction.normalized() * speed
	position = position.lerp(position + target_velocity, delta * 10.0)

	global_position.x = clamp(global_position.x, min_boundary.x, max_boundary.x)
	global_position.y = clamp(global_position.y, min_boundary.y, max_boundary.y)
