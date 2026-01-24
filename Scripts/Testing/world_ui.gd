extends CanvasLayer

@onready var inventory_ui = $InventoryUI

func _ready():
	inventory_ui.visible = false

func _input(event):
	if event.is_action_pressed("open_inventory"):
		toggle_inventory()
	if (event.is_action_pressed("ui_cancel") && inventory_ui.visible):
		toggle_inventory()
		

func toggle_inventory():
	inventory_ui.visible = !inventory_ui.visible
	
	if inventory_ui.visible:
		# refresh data item
		inventory_ui.fill_grid()
		get_tree().paused = true
	else:
		get_tree().paused = false
		pass

func _on_inventory_button_pressed():
	toggle_inventory()
