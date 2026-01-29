extends Area2D

@export_file("*.tscn") var next_scene_path: String
@export var entry_point_id: String = "Level1_Start"
@export var door_open_sfx: AudioStream
@export var basement_door: bool = false

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		if basement_door:
			print("AWWW")
			if not InventoryManager.has_item_by_id("clue_kunci_basement"):
				print("Asdd")
				%DoorLocked.play()
				_show_locked_dialog()
				return
		
		set_deferred("monitoring", false)
		body.set_process(false) 
		
		_play_door_sound()
		_perform_fade_transition()

func _show_locked_dialog():
	%MonodialogEventTrigger.start_monodialog("110")

func _play_door_sound():
	if door_open_sfx:
		var audio = AudioStreamPlayer.new()
		audio.stream = door_open_sfx
		add_child(audio)
		audio.play()
		audio.finished.connect(audio.queue_free)

func _perform_fade_transition():
	var black_rect = ColorRect.new()
	black_rect.color = Color.BLACK
	black_rect.modulate.a = 0 # Mulai dari transparan
	black_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	black_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(black_rect)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(black_rect, "modulate:a", 1.0, 0.4)
	
	await tween.finished
	
	GameManager.target_entry_id = entry_point_id
	get_tree().call_deferred("change_scene_to_file", next_scene_path)
