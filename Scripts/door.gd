extends Area2D

@export_file("*.tscn") var next_scene_path: String # Choose the scene file
@export var entry_point_id: String = "Level1_Start" # Where the player should land

func _on_body_entered(body) -> void:
	print(body.name)
	if body.is_in_group("player"):
		GameManager.target_entry_id = entry_point_id
		get_tree().change_scene_to_file(next_scene_path)
	#if body.is_in_group("player"):
		# Save the entry point ID in a Global/Autoload so the new scene knows where to put you
