extends Area2D

static var active_piece: Area2D = null

var dragging := false
var offset := Vector2.ZERO

@export var piece_texture: Texture2D

func _ready():
	if piece_texture:
		$Sprite2D.texture = piece_texture

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + offset

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if active_piece != null:
				return  # another piece is already being dragged

			active_piece = self
			dragging = true
			offset = global_position - get_global_mouse_position()
			z_index = 1000  # bring to front
		else:
			if active_piece == self:
				active_piece = null
				dragging = false
				z_index = 0
