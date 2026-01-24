extends Node2D

@export var checkpoint_scene: PackedScene
@onready var objects_layer: TileMapLayer = $TileMap/Objects

func _ready():
	spawn_checkpoints()

func spawn_checkpoints():
	for cell in objects_layer.get_used_cells():
		var tile_data = objects_layer.get_cell_tile_data(cell)
		if tile_data == null:
			continue

		if tile_data.get_custom_data("is_checkpoint"):
			var checkpoint = checkpoint_scene.instantiate()

			# Convert cell → world position
			checkpoint.global_position = objects_layer.map_to_local(cell)

			checkpoint.activated.connect(_on_checkpoint_activated)
			add_child(checkpoint)

func _on_checkpoint_activated(position: Vector2):
	CheckpointState.set_checkpoint(position)
	print("Checkpoint saved at:", position)
