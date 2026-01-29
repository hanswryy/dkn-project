extends Node

const MAX_SLOTS = 20
var items: Array[ItemData] = []

signal inventory_updated
# send item data to HighlightItem scene
signal item_highlight_requested(item_data: ItemData)
signal magnification_started

# appending item (testing)
func _ready():
	#add_item(load(Constants.SCENE_PATHS.basement_key))
	#add_item(load(Constants.SCENE_PATHS.clue_kupu_kupu))
	#add_item(load(Constants.SCENE_PATHS.magnifying_glass))
	#add_item(load(Constants.SCENE_PATHS.surat_sita_bank))
	#add_item(load(Constants.SCENE_PATHS.surat_dari_matt))
	#add_item(load(Constants.SCENE_PATHS.tiket_kereta))
	#add_item(load(Constants.SCENE_PATHS.diary_lily))
	#add_item(load(Constants.SCENE_PATHS.clue_tisu))
	#add_item(load(Constants.SCENE_PATHS.clue_cangkir))
	#add_item(load(Constants.SCENE_PATHS.botol_racun))
	#add_item(load(Constants.SCENE_PATHS.kunci_kupu))
	pass

func add_item(item: ItemData):
	print("Item Added:" + str(item))
	items.append(item)
	inventory_updated.emit()
	
func has_item_by_id(target_id: String) -> bool:
	print(items)
	return items.any(
		func(item): 
			print("Test2 :" + str(item))
			return item != null and item.id == target_id
	)
	
# check if player has magnifying glass in their inventory
func has_magnifying_glass() -> bool:
	return has_item_by_id("item_kaca_pembesar")
	
func magnify_item(old_item: ItemData):
	magnification_started.emit()
	await get_tree().create_timer(1.5).timeout
	var index = items.find(old_item)
	
	# change item in the array
	if index != -1 and old_item.revealedVersion:
		items[index] = old_item.revealedVersion
		inventory_updated.emit()
	
