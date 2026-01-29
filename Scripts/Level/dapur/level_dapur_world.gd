extends Node2D

@export var dnd_scene: PackedScene

@onready var tilemap: TileMap = $TileMap
@onready var objects_layer: TileMapLayer = $TileMap/Objects
@onready var player = $Player

var pending_object_cell: Vector2i = Vector2i(-1, -1)

func _ready() -> void:
	# 1. Cari node (Marker2D atau Area2D) yang punya Group ID sesuai dari GameManager
	var spawn_node = get_tree().get_first_node_in_group(GameManager.target_entry_id)
	# 2. Jika ketemu, pindahkan Player ke posisi node tersebut
	if spawn_node:
		player.global_position = spawn_node.global_position
		
	$CanvasModulate.show()

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		handle_tile_click(event.position)

func handle_tile_click(mouse_pos: Vector2):
	var cell = objects_layer.local_to_map(
		objects_layer.to_local(get_global_mouse_position())
	)

	var tile_data = objects_layer.get_cell_tile_data(cell)
	if tile_data == null:
		return

	if tile_data.get_custom_data("is_checkpoint"):\
		request_object_inspection(cell)

func request_object_inspection(cell: Vector2i):
	pending_object_cell = cell
	
	var object_cell = cell
	var stand_cell = tilemap.get_interaction_cell(object_cell, player.global_position)
	player.move_to_cell(stand_cell)

func _on_player_arrived():
	if pending_object_cell == Vector2i(-1, -1):
		return

	spawn_inspect_window()
	pending_object_cell = Vector2i(-1, -1)

func spawn_inspect_window():
	var obj = dnd_scene.instantiate()
	InspectWindowController.is_in_inspect_window = true
	add_child(obj)
	move_child(obj, 0)

func _on_object_activated():
	print("object interacted")
