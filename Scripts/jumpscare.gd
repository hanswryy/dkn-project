extends Node2D
@export var stretch_mode : bool = false
@export var jumpscare_duration : float = 1.5

# >>> Path ke trigger Area2D (atur di inspector)
@export var trigger_area_path : NodePath = "../JumpscareTrigger"

var is_jumpscare_active : bool = false
var has_been_triggered : bool = false  # >>> Jumpscare hanya sekali

func _ready():
	setup_jumpscare_ui()
	setup_trigger()

func setup_jumpscare_ui():
	var sprite = $CanvasLayer/JumpscareSprite
	sprite.centered = true
	sprite.position = get_viewport().get_visible_rect().size / 2
	
	if not sprite.texture:
		push_error("JumpscareSprite tidak punya texture!")
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var texture_size = sprite.texture.get_size()
	
	if stretch_mode:
		sprite.scale = viewport_size / texture_size
	else:
		var scale_x = viewport_size.x / texture_size.x
		var scale_y = viewport_size.y / texture_size.y
		var min_scale = min(scale_x, scale_y)
		sprite.scale = Vector2(min_scale, min_scale)
	
	$CanvasLayer/JumpscareSprite.z_index = 1
	$CanvasLayer/ColorRect.z_index = 0
	
	$CanvasLayer/JumpscareSprite.hide()
	$CanvasLayer/ColorRect.hide()

func setup_trigger():
	if trigger_area_path:
		var trigger_area = get_node_or_null(trigger_area_path)
		if trigger_area:
			trigger_area.body_entered.connect(_on_trigger_body_entered)
			print("Trigger connected: ", trigger_area.name)
		else:
			push_error("Trigger Area2D tidak ditemukan di path: " + str(trigger_area_path))
	else:
		push_error("Trigger Area Path belum diatur!")

# >>> TRIGGER: Player masuk Area2D
func _on_trigger_body_entered(body):
	print("ez")
	if body.name == "Player":
		# >>> Langsung trigger jika belum pernah
		if not has_been_triggered and not is_jumpscare_active:
			trigger_jumpscare()

func trigger_jumpscare():
	is_jumpscare_active = true
	has_been_triggered = true  # >>> Mark sebagai sudah triggered
	
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/JumpscareSprite.show()
	
	if has_node("JumpscareAudio"):
		$JumpscareAudio.pitch_scale = 1.0
		$JumpscareAudio.play()
	
	shake_screen(jumpscare_duration)
	
	await get_tree().create_timer(jumpscare_duration).timeout
	
	$CanvasLayer/ColorRect.hide()
	$CanvasLayer/JumpscareSprite.hide()
	is_jumpscare_active = false

func shake_screen(duration: float):
	var sprite = $CanvasLayer/JumpscareSprite
	var original_pos = sprite.position
	
	var shake_count = int(duration * 20)
	var shake_interval = duration / shake_count
	
	for i in range(shake_count):
		var intensity = 30.0 * (1.0 - float(i) / shake_count)
		sprite.position = original_pos + Vector2(
			randf_range(-intensity, intensity), 
			randf_range(-intensity, intensity)
		)
		await get_tree().create_timer(shake_interval).timeout
	
	sprite.position = original_pos

# >>> Opsional: Force jumpscare (untuk testing)
func force_jumpscare():
	if not is_jumpscare_active and not has_been_triggered:
		trigger_jumpscare()

# >>> Opsional: Reset untuk testing/debugging
func reset_jumpscare():
	has_been_triggered = false
	is_jumpscare_active = false
	print("Jumpscare reset - can trigger again")
	
func start_manual_jumpscare():
	if not JumpscareManager.jumpscare_bathtub_triggered:
		JumpscareManager.jumpscare_bathtub_triggered = true
		trigger_jumpscare()
