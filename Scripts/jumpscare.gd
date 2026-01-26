extends Node2D

@export var jumpscare_chance : float = 100.0
@export var cooldown_seconds : float = 10.0
@export var min_distance_trigger : float = 50.0
@export var stretch_mode : bool = false
@export var jumpscare_duration : float = 1.5

var cooldown_timer : float = 0.0
var is_jumpscare_active : bool = false

func _ready():
	setup_jumpscare_ui()
	
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_trigger_area_entered)

func setup_jumpscare_ui():
	# Setup sprite
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
	
	# Pastikan z_index (sprite di atas background)
	$CanvasLayer/JumpscareSprite.z_index = 1
	$CanvasLayer/ColorRect.z_index = 0
	
	# Sembunyikan di awal
	$CanvasLayer/JumpscareSprite.hide()
	$CanvasLayer/ColorRect.hide()

func _process(delta):
	if is_jumpscare_active:
		return
	
	cooldown_timer -= delta
	if cooldown_timer <= 0:
		attempt_jumpscare()
		cooldown_timer = cooldown_seconds

func attempt_jumpscare():
	if has_node("../Player"):
		var player = get_node("../Player")
		if global_position.distance_to(player.global_position) > min_distance_trigger:
			return
	
	trigger_jumpscare()

func trigger_jumpscare():
	is_jumpscare_active = true
	
	# TAMPILKAN BACKGROUND HITAM + SPRITE
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/JumpscareSprite.show()
	
	if has_node("JumpscareAudio"):
		$JumpscareAudio.pitch_scale = randf_range(0.9, 1.1)
		$JumpscareAudio.play()
	
	shake_screen(jumpscare_duration)
	
	await get_tree().create_timer(jumpscare_duration).timeout
	
	# SEMBUNYIKAN KEDUANYA
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

func _on_trigger_area_entered(body):
	if body.name == "Player" and cooldown_timer <= 0:
		attempt_jumpscare()

func force_jumpscare():
	if not is_jumpscare_active:
		trigger_jumpscare()
