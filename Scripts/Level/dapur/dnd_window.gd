extends CanvasLayer

@onready var close_button :TextureButton = $CloseButton

func _on_close_button_pressed() -> void:
	InspectWindowController.is_in_inspect_window = false
	queue_free()
