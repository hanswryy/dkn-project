extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true

func _on_button_2_pressed() -> void:
	fade_out($BGM, 4)
	FadeToBlack_Transition.fade_to_scene("res://Scenes/world.tscn", 4)

func _on_button_3_pressed() -> void:
	pass # Replace with function body.

func _on_button_4_pressed() -> void:
	get_tree().quit()

func fade_out(player: AudioStreamPlayer, duration := 1.0):
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -80, duration)
	tween.finished.connect(player.stop)
