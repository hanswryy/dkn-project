extends Area2D

@export var item: ItemData 

@onready var sprite = $Sprite2D

func _ready():
	if item:
		sprite.texture = item.icon
	
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_highlight)
	mouse_exited.connect(_off_mouse_highlight)
	
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed and !get_tree().paused:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# tell player to start moving to item position
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.target_item = self
				print("Target Item Coord: " + str(player.target_item))
				player.get_coord_to_pos(global_position)

func pick_up():
	if item:
		%PickupSFX.play()
		
		# Append item to inventory array
		InventoryManager.add_item(item)
		
		InventoryManager.item_highlight_requested.emit(item)
		queue_free()

func _on_mouse_highlight():
	sprite.modulate = Color(1.3, 1.3, 1.3) 

func _off_mouse_highlight():
	sprite.modulate = Color(1, 1, 1)
