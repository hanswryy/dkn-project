extends Node2D

@export var min_interval : float = 1.0
@export var max_interval : float = 2.0
@export var disturbance_chance : float = 100.0
@export var player_proximity : float = 200.0

var player : CharacterBody2D = null
var timer : float = 0.0
var next_interval : float = 0.0

func _ready():
	# >>> Player adalah parent langsung
	player = get_parent() as CharacterBody2D
	
	if not player:
		push_error("Parent bukan CharacterBody2D!")
		return
	
	print("Player ditemukan: ", player.name)
	
	# Cek audio
	if not has_node("door_knock"):
		push_error("Node door_knock tidak ditemukan!")
	else:
		print("door_knock ditemukan")
	
	randomize_next_interval()

func _process(delta):
	if not player:
		return
	
	timer += delta
	
	if timer >= next_interval:
		timer = 0.0
		attempt_disturbance()
		randomize_next_interval()

func randomize_next_interval():
	next_interval = randf_range(min_interval, max_interval)

func attempt_disturbance():
	# >>> Jarak dari POSISI GLOBAL sound_disturbance ke player (parent)
	# Karena child dari player, jaraknya selalu 0, jadi pakai offset atau logika lain
	
	# Opsi 1: Cek jarak player ke posisi tertentu di world
	var world_pos = global_position  # posisi global sound_disturbance
	var player_pos = player.global_position
	
	# Karena child player, jarak ~0, gunakan logic berbeda
	# Misal: trigger berdasarkan posisi player di world, atau random saja
	
	# Opsi 2: Random tanpa cek jarak (karena selalu dekat)
	var roll = randf() * 100.0
	if roll > disturbance_chance:
		return
	
	play_disturbance()

func play_disturbance():
	if not has_node("door_knock"):
		return
	
	var audio = $door_knock
	
	if audio.playing:
		return
	
	# Variasi
	audio.pitch_scale = randf_range(0.8, 1.2)
	audio.volume_db = randf_range(-10.0, 0.0)
	
	# >>> Posisi audio: random di sekitar PLAYER (parent)
	var random_offset = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	audio.global_position = player.global_position + random_offset
	
	audio.play()
	print("Door knock played at: ", audio.global_position)

func force_disturbance():
	play_disturbance()
