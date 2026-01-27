extends Camera2D

func _input(event):
	if event.is_action("MWheel_Down"):
		if zoom.x > 1:
			var mouse_position = get_viewport().get_mouse_position()
			var pre_zoom_value = zoom

			zoom -= Vector2(0.25, 0.25)
			zoom.x = max(zoom.x, 1)
			zoom.y = max(zoom.y, 1)

			position += (mouse_position - position) * \
			(Vector2.ONE - pre_zoom_value / zoom)

	elif event.is_action("MWheel_Up"):
		if zoom.x < 4:
			var mouse_position = get_viewport().get_mouse_position()
			var pre_zoom_value = zoom

			zoom += Vector2(0.25, 0.25)
			zoom.x = min(zoom.x, 4)
			zoom.y = min(zoom.y, 4)

			position += (mouse_position - position) * \
			(Vector2.ONE - pre_zoom_value / zoom)
