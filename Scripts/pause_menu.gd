extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.visible = false
	get_tree().paused = false

func toggle_pause() -> void:
	$ColorRect.visible = not $ColorRect.visible
	get_tree().paused = not get_tree().paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		if $Button.visible:
			$Button.visible = false

func _on_button_pressed() -> void:
	toggle_pause()
	$Button.visible = false

func _on_button_2_pressed() -> void:
	toggle_pause()
	$Button.visible = true

func _on_button_mouse_entered() -> void:
	PauseGameController.is_in_pause_box = true
