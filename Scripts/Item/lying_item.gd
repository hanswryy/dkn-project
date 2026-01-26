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
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pick_up()

func pick_up():
	if item:
		# Append item to inventory array
		InventoryManager.add_item(item)
		print("Item Collected: ", item.name)
		
		queue_free()

func _on_mouse_highlight():
	sprite.modulate = Color(1.3, 1.3, 1.3) 

func _off_mouse_highlight():
	sprite.modulate = Color(1, 1, 1)
