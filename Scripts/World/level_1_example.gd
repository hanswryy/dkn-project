extends Node2D

@export var checkpoint_scene: PackedScene

@onready var tilemap: TileMap = $TileMap
@onready var objects_layer: TileMapLayer = $TileMap/Objects
@onready var player = $Player

var pending_checkpoint_cell: Vector2i = Vector2i(-1, -1)

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
		request_checkpoint_inspection(cell)

func request_checkpoint_inspection(cell: Vector2i):
	pending_checkpoint_cell = cell
	
	var object_cell = cell
	var stand_cell = tilemap.get_interaction_cell(object_cell, player.global_position)
	player.move_to_cell(stand_cell)

func _on_player_arrived():
	if pending_checkpoint_cell == Vector2i(-1, -1):
		return

	spawn_checkpoint(pending_checkpoint_cell)
	pending_checkpoint_cell = Vector2i(-1, -1)

func spawn_checkpoint(cell: Vector2i):
	var checkpoint = checkpoint_scene.instantiate()
	checkpoint.global_position = tilemap.map_to_local(cell)
	checkpoint.activated.connect(_on_checkpoint_activated)
	add_child(checkpoint)

func _on_checkpoint_activated(position: Vector2):
	CheckpointState.set_checkpoint(position)
	print("Checkpoint saved at:", position)
