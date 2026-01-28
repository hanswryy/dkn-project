extends CanvasLayer

@onready var close_button :TextureButton = $CloseButton

func _on_close_button_pressed() -> void:
	InspectWindowController.is_in_inspect_window = false
	queue_free()

func _ready() -> void:
	var clue_botol = get_child(1).get_child(0)
	var clue_noda = get_child(1).get_child(1)
	if InventoryManager.has_item_by_id("clue_botol_racun"):
		clue_botol.queue_free()
	if InventoryManager.has_item_by_id("clue_tisu"):
		clue_noda.queue_free()
