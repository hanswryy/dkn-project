extends PanelContainer

signal slot_clicked(data: ItemData)

var current_item_data: ItemData

@onready var icon = $MarginContainer/Icon

func display_item(item_data: ItemData):
	current_item_data = item_data
	if item_data:
		icon.texture = item_data.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			slot_clicked.emit(current_item_data)
