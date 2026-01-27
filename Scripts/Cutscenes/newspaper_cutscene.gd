extends Node2D

func _on_button_pressed() -> void:
	$ColorRect/Button1.disabled = true
	var blur_overlay = $ColorRect
	var tween = create_tween()
	if blur_overlay.modulate.a > 0:
		# Fade out the blur
		tween.tween_property(blur_overlay, "modulate:a", 0.0, 0.3)

func _on_button_2_pressed() -> void:
	$ColorRect2/Button2.disabled = true
	var blur_overlay = $ColorRect2
	var tween = create_tween()
	if blur_overlay.modulate.a > 0:
		# Fade out the blur
		tween.tween_property(blur_overlay, "modulate:a", 0.0, 0.3)

func _on_button_3_pressed() -> void:
	$ColorRect3/Button3.disabled = true
	var blur_overlay = $ColorRect3
	var tween = create_tween()
	if blur_overlay.modulate.a > 0:
		# Fade out the blur
		tween.tween_property(blur_overlay, "modulate:a", 0.0, 0.3)

func _on_button_4_pressed() -> void:
	$ColorRect4/Button4.disabled = true
	var blur_overlay = $ColorRect4
	var tween = create_tween()
	if blur_overlay.modulate.a > 0:
		# Fade out the blur
		tween.tween_property(blur_overlay, "modulate:a", 0.0, 0.3)

func _on_button_5_pressed() -> void:
	$ColorRect5/Button5.disabled = true
	var blur_overlay = $ColorRect5
	var tween = create_tween()
	if blur_overlay.modulate.a > 0:
		# Fade out the blur
		tween.tween_property(blur_overlay, "modulate:a", 0.0, 0.3)

func _on_button_6_pressed() -> void:
	$ColorRect6/Button6.disabled = true
	var blur_overlay = $ColorRect6
	var tween = create_tween()
	if blur_overlay.modulate.a > 0:
		# Fade out the blur
		tween.tween_property(blur_overlay, "modulate:a", 0.0, 0.3)
