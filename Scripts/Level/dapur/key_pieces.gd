extends Area2D

@export var piece_texture: Texture2D
@export var item: ItemData 

var clickable = false

func _ready():
	
	if piece_texture:
		$Sprite2D.texture = piece_texture
	else:
		$Sprite2D.texture = item.icon

func _physics_process(_delta):
	var overlap_count := get_overlapping_areas().size()
	if overlap_count == 0:
		clickable = true
	else:
		clickable = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_mbutton") and clickable:
		# Append item to inventory array
		InventoryManager.add_item(item)
		InventoryManager.item_highlight_requested.emit(item)
		print("congrats")
		queue_free()
