extends Control

@onready var texture_gelas = $PanelContainer/TextureBathroom/TextureCurtain
@onready var clickable_area = $ClickableArea

@export var item_data: ItemData

func _ready():
	texture_gelas.show()
	clickable_area.show()
	SignalManager.cangkir_interaction_requested.connect(_on_interaction_requested)

func _on_clickable_area_pressed() -> void:
	%PickupSFX.play()
	InventoryManager.add_item(item_data)
	
	# hide glass texture when clicked
	var tween = create_tween()
	tween.tween_property(texture_gelas, "modulate:a", 0.0, 0.2)
	await tween.finished
	texture_gelas.hide()
	clickable_area.hide()
	
	# signal jumpscare
	#InventoryManager.item_highlight_requested.emit(item_data)
	
func _on_interaction_requested():
	show()
	
func _on_button_close_pressed() -> void:
	self.hide()
