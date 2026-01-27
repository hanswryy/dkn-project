extends Node2D

@export var checkpoint_scene: PackedScene
@export var item_scene: PackedScene

@onready var interaction := $InteractionController

func _ready():
	interaction.interaction_resolved.connect(_on_interaction)

func _on_interaction(type: int, cell: Vector2i):
	match type:
		InteractionType.CHECKPOINT:
			_spawn_checkpoint(cell)
		InteractionType.ITEM_PICKUP:
			_pickup_item(cell)
		InteractionType.INTERACT_ONLY:
			_show_lore(cell)

func _spawn_checkpoint(cell: Vector2i):
	var cp = checkpoint_scene.instantiate()
	cp.global_position = $TileMap.map_to_local(cell)
	add_child(cp)

func _pickup_item(cell: Vector2i):
	#example: Inventory.add_item_from_tile(cell)
	pass

func _show_lore(cell: Vector2i):
	#LoreUI.show_from_tile(cell)
	pass
