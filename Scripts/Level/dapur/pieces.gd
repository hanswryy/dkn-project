extends Node2D

@export var piece_texture: Texture2D

static var active_piece: Node2D = null

var selected := false
var offset := Vector2.ZERO

func _ready() -> void:
	if piece_texture:
		$Sprite2D.texture = piece_texture

func _on_area_2d_input_event(viewport, event, shape_idx) -> void:

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if active_piece != null:
				return

			active_piece = self
			selected = true
			offset = global_position - get_global_mouse_position()
			z_index = 1000
			get_viewport().set_input_as_handled()
		else:
			if active_piece == self:
				selected = false
				active_piece = null
				z_index = 0

func _physics_process(delta: float) -> void:
	if selected:
		global_position = global_position.lerp(
			get_global_mouse_position() + offset,
			25 * delta
		)
