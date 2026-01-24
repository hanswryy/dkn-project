extends Node

#var current_level_path: String = ""
var checkpoint_position: Vector2 = Vector2.ZERO
var has_checkpoint := false

func set_checkpoint(position: Vector2):
	checkpoint_position = position
	has_checkpoint = true
