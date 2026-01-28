extends PanelContainer

signal slot_clicked(item_data: ItemData, slot_node: PanelContainer)

var current_item_data: ItemData
var is_selected: bool = false # Gunakan snake_case (standar GDScript)

@onready var icon = $MarginContainer/Icon

func display_item(item_data: ItemData):
	current_item_data = item_data
	if item_data:
		icon.texture = item_data.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false
		
func set_selected(state: bool):
	is_selected = state
	_update_visual()

func _update_visual():
	if is_selected:
		self.modulate = Color(1, 1, 1, 0.5) 
	else:
		self.modulate = Color(1, 1, 1, 1)

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			slot_clicked.emit(current_item_data, self)


func _on_mouse_entered() -> void:
	if not is_selected:
		self.modulate = Color(1, 1, 1, 0.7)

func _on_mouse_exited() -> void:
	_update_visual()
