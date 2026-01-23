extends Node

signal inventory_updated

var items: Array[ItemData] = []

# appending item test
func _ready():
	add_item(load(Constants.SCENE_PATHS.example_item_1))
	add_item(load(Constants.SCENE_PATHS.example_item_2))
	pass

func add_item(item: ItemData):
	items.append(item)
	inventory_updated.emit()
	print("Item Collected: ", item.name)
