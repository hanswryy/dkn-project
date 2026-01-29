# JumpscareManager.gd
extends Node

# Array simpan path scene (.tscn) yang sudah pernah jumpscare
var triggered_rooms: Array[String] = []
var jumpscare_bathtub_triggered: bool = false

# Tandai suatu ruangan (path scene) sudah pernah jumpscare
func mark_triggered(scene_path: String) -> void:
	if not scene_path in triggered_rooms:
		triggered_rooms.append(scene_path)

# Cek apakah ruangan (path scene) sudah pernah jumpscare
func is_triggered(scene_path: String) -> bool:
	return scene_path in triggered_rooms

# Reset semua data (dipakai menu utama / new game)
func reset_all() -> void:
	triggered_rooms.clear()
