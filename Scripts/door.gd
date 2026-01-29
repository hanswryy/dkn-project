extends Area2D

@export_file("*.tscn") var next_scene_path: String
@export var entry_point_id: String = "Level1_Start"

func _on_body_entered(body) -> void:
	print(body.name)
	if body.is_in_group("player"):
		# Set entry point (Ini aman dilakukan langsung)
		GameManager.target_entry_id = entry_point_id
		
		# --- PERBAIKAN: Gunakan call_deferred ---
		# Format: call_deferred("nama_fungsi_string", argumen_1, argumen_2, ...)
		get_tree().call_deferred("change_scene_to_file", next_scene_path)
