extends Area2D
@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	# pastikan hanya 1 kali connect
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# tunda sampai frame ini selesai
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_file(next_scene)
