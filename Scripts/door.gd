extends Area2D

@export_file("*.tscn") var next_scene_path: String
@export var entry_point_id: String = "Level1_Start"
@export var door_open_sfx: AudioStream

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		set_deferred("monitoring", false)
		
		# --- BONUS: Bekukan player agar tidak gerak saat fade ---
		# Ini membuat transisi terasa lebih bersih
		body.set_process(false) # Matikan proses logic player
		
		_play_door_sound()
		_perform_fade_transition()

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
	black_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	black_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(black_rect)
	
	var tween = create_tween()
	
	# --- BAGIAN UTAMA MEMBUAT CEPAT ---
	
	# 1. Ubah Easing: EASE_IN (Mulai pelan, lalu langsung hitam cepat)
	# Lebih cocok untuk durasi pendek daripada EASE_IN_OUT
	tween.set_ease(Tween.EASE_IN)
	
	# 2. Tipe Transisi: TRANS_SINE (Lebih sederhana dan cepat)
	tween.set_trans(Tween.TRANS_SINE)
	
	# 3. UBAH DURASI: Dari 1.5 menjadi 0.4 detik
	tween.tween_property(black_rect, "modulate:a", 1.0, 0.4)
	
	await tween.finished
	
	GameManager.target_entry_id = entry_point_id
	get_tree().call_deferred("change_scene_to_file", next_scene_path)
