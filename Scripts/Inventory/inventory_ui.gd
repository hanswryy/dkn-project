extends Control

const SLOT_SCENE = preload("res://Scenes/Inventory/inventory_slot.tscn")

@onready var grid = $PanelContainer/MarginContainer/ItemGrid

func _ready():
	InventoryManager.inventory_updated.connect(fill_grid)
	fill_grid()

func fill_grid():
	# clear previous grid
	for child in grid.get_children():
		child.queue_free()
	
	for item in InventoryManager.items:
		var new_slot = SLOT_SCENE.instantiate()
		grid.add_child(new_slot)
		new_slot.display_item(item)
