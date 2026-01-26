extends Control

@onready var item_icon = %ItemIcon
@onready var item_name = %ItemName
@onready var item_description = %ItemDescription
#@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	InventoryManager.item_highlight_requested.connect(_on_item_highlight)

func _on_item_highlight(item_data: ItemData):
	print(str(item_data.icon))
	item_icon.texture = item_data.icon
	item_name.text = item_data.name
	item_description.text = item_data.description
	
	show_highlight()
	
func show_highlight():
	visible = true
	get_tree().paused = true
	
func _input(event):
	if visible and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			hide_highlight()
			get_viewport().set_input_as_handled()
		
func hide_highlight():
	get_tree().paused = false
	visible = false
