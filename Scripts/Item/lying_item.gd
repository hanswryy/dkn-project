extends Area2D

@export var item: ItemData 
@export var target_size: Vector2 = Vector2(20, 20)

@onready var sprite = $Sprite2D

func _ready():
	if InventoryManager.has_item_by_id(item.id):
		print("Item ", item.name, " sudah ada di tas. Menghapus dari map.")
		queue_free()
		
	if item:
		sprite.texture = item.icon
		_rescale_sprite()
	
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_highlight)
	mouse_exited.connect(_off_mouse_highlight)

func _rescale_sprite():
	if sprite.texture == null: return
	
	var texture_size: Vector2
	if sprite.texture is AtlasTexture:
		texture_size = sprite.texture.region.size
	else:
		texture_size = sprite.texture.get_size()
	
	var scale_factor = Vector2(
		target_size.x / texture_size.x,
		target_size.y / texture_size.y
	)
	
	var final_scale = min(scale_factor.x, scale_factor.y)
	sprite.scale = Vector2(final_scale, final_scale)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and !get_tree().paused:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.target_item = self
				player.get_coord_to_pos(global_position)

func pick_up():
	if item:
		%PickupSFX.play()
		InventoryManager.add_item(item)
		InventoryManager.item_highlight_requested.emit(item)
		queue_free()

func _on_mouse_highlight():
	sprite.modulate = Color(1.3, 1.3, 1.3) 

func _off_mouse_highlight():
	sprite.modulate = Color(1, 1, 1)
