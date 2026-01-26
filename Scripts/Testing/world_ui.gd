extends CanvasLayer

@onready var inventory_ui = $InventoryUI
@onready var inv_button = %InventoryButton

@export var icon_open : Texture2D
@export var icon_close : Texture2D

func _ready():
	inventory_ui.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("open_inventory"):
		toggle_inventory()
	if (event.is_action_pressed("ui_cancel") && inventory_ui.visible):
		toggle_inventory()
		

func toggle_inventory():
	inventory_ui.visible = !inventory_ui.visible
	
	if inventory_ui.visible:
		%OpenInventorySFX.play()
		# refresh data item
		inventory_ui.fill_grid()
		get_tree().paused = true
		inv_button.icon = icon_open
	else:
		%CloseInventorySFX.play()
		get_tree().paused = false
		inv_button.icon = icon_close
		pass

func _on_inventory_button_pressed():
	toggle_inventory()
