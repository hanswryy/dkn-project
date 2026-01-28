extends Area2D

@export_enum("Cangkir", "Laci", "Gembok", "Bathtub", "Lukisan") var clue_type: String = "Cangkir"

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var player = get_tree().get_first_node_in_group("player")
			if player:
				# set target
				player.target_item = self
				# move player
				player.get_coord_to_pos(global_position)

func pick_up():
	print("Player sampai di: ", clue_type)
	
	match clue_type:
		"Cangkir":
			SignalManager.cangkir_interaction_requested.emit()
		"Laci":
			SignalManager.drawer_interaction_requested.emit()
		"Gembok":
			SignalManager.padlock_interaction_requested.emit()
		"Bathtub":
			SignalManager.bathtub_interaction_requested.emit()
