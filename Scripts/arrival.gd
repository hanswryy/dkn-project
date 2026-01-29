extends Node2D # Ini adalah script di root Level_2

func _ready() -> void:
	# 1. Cari node (Marker2D atau Area2D) yang punya Group ID sesuai dari GameManager
	var spawn_node = get_tree().get_first_node_in_group(GameManager.target_entry_id)
	# 2. Jika ketemu, pindahkan Player ke posisi node tersebut
	if spawn_node:
		$Player.global_position = spawn_node.global_position
		
	$CanvasModulate.show()
