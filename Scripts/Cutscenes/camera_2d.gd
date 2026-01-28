extends Control

var default_x: float
var default_y: float

var zoom: float = 1

var mouse_pos_relative_to_cam_x: float
var mouse_pos_relative_to_cam_y: float

var is_panning := false
var last_mouse_pos := Vector2.ZERO

@export var min_bounds: Vector2 = Vector2(-100, -50)
@export var max_bounds: Vector2 = Vector2(100, 1000)

func _ready() -> void:
	default_x = position.x
	default_y = position.y
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(delta: float) -> void:
	#if is_panning: return
	var remappedZoom = remap(zoom, 0.6, 1.25, 0.4, 1)
	var target_x = default_x + mouse_pos_relative_to_cam_x * .5 * remappedZoom
	var target_y = default_y + mouse_pos_relative_to_cam_y * 1.75 * remappedZoom
	position.x = lerpf(position.x, target_x, 0.005)
	position.y = lerpf(position.y, target_y, 0.005)
	position.x = clampf(position.x, min_bounds.x, max_bounds.x)
	position.y = clampf(position.y, min_bounds.y, max_bounds.y)
	zoom = clampf(zoom, 0.7, 1.25)
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(zoom, zoom), 0.1)

func _input(event: InputEvent) -> void:
	# Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom -= 0.05
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom += 0.05

		# Start / stop panning
		#elif event.button_index == MOUSE_BUTTON_LEFT:
			#is_panning = event.pressed
			#last_mouse_pos = event.position

	# Mouse motion
	elif event is InputEventMouseMotion:
		mouse_pos_relative_to_cam_x = event.position.x - 1280 / 2
		mouse_pos_relative_to_cam_y = event.position.y - 720 / 2

		# Pan camera while dragging
		#if is_panning:
			#var delta: Vector2 = event.position - last_mouse_pos
			#position -= delta * zoom
			#last_mouse_pos = event.position
