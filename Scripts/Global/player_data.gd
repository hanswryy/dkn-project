extends Node

signal inventory_updated

var items: Array[ItemData] = []

func add_item(item: ItemData):
	items.append(item)
	inventory_updated.emit()
	print("Item Collected: ", item.name)
