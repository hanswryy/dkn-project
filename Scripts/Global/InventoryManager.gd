extends Node

signal inventory_updated

var items: Array[ItemData] = []

# appending item test
func _ready():
	add_item(load("res://Scripts/Item/example-item.tres"))
	add_item(load("res://Scripts/Item/example-item-2.tres"))
	pass

func add_item(item: ItemData):
	items.append(item)
	inventory_updated.emit()
	print("Item Collected: ", item.name)
