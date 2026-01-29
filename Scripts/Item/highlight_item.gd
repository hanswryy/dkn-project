extends Control

@onready var item_icon = %ItemIcon
@onready var item_name = %ItemName
@onready var item_description = %ItemDescription

var original_pos_y : float
var postDialogId = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	InventoryManager.item_highlight_requested.connect(_on_item_highlight)
	original_pos_y = self.position.y
	
func _input(event):
	if visible and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			hide_highlight()
			get_viewport().set_input_as_handled()

func _on_item_highlight(item_data: ItemData):
	item_icon.texture = item_data.icon
	item_name.text = item_data.name
	item_description.text = item_data.description
	postDialogId = item_data.postRevealDialog
	
	show_highlight()
	
func show_highlight():
	visible = true
	get_tree().paused = true
	
	animate_open()
	animate_icon()
	

func hide_highlight():
	%PutItemSFX.play()
	await animate_close()
	SignalManager.highlight_closed.emit()
	
	get_tree().paused = false
	visible = false
	
# ================================= ANIMATION FUNC =================================
	
# highlight minor animation
func animate_open():
	self.show()
	self.position.y = original_pos_y + 20
	self.modulate.a = 0
	
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate:a", 1.0, 0.4)
	tween.tween_property(self, "position:y", original_pos_y, 0.5)

# animate icon	
func animate_icon():
	var icon = %ItemIcon
	var original_y = 250
	
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.tween_property(icon, "position:y", original_y - 5, 2.0)
	tween.tween_property(icon, "position:y", original_y, 2.0)
	
# close highlight minor animation
func animate_close():
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_property(self, "position:y", original_pos_y + 20, 0.5)
	
	await tween.finished
	self.hide()
	self.position.y = original_pos_y
	
	%MonodialogEventTrigger.start_monodialog(postDialogId)
