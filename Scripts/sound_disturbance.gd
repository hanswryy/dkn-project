extends Node2D

@export var min_interval : float = 8.0
@export var max_interval : float = 20.0

@export var door_knock_chance : float = 40.0
@export var walking_step_chance : float = 60.0
@export var bisikan_chance : float = 30.0
@export var droplet_chance : float = 50.0

@export var player_proximity : float = 200.0

# >>> MAKSIMAL 1 SUARA PER DISTURBANCE
const MAX_SOUNDS_PER_DISTURBANCE : int = 1

var audio_chances : Dictionary = {}

var player : CharacterBody2D = null
var timer : float = 0.0
var next_interval : float = 0.0

func _ready():
	player = get_parent() as CharacterBody2D
	
	if not player:
		return
	
	audio_chances["door_knock"] = door_knock_chance
	audio_chances["walking_step"] = walking_step_chance
	audio_chances["bisikan"] = bisikan_chance
	audio_chances["droplet"] = droplet_chance
	
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
	play_random_disturbance()

func play_random_disturbance():
	# >>> SHUFFLE ARRAY UNTUK URUTAN ACAK
	var shuffled_sounds = audio_chances.keys()
	shuffled_sounds.shuffle()
	
	# >>> CARI 1 SUARA YANG BERHASIL ROLL
	for audio_name in shuffled_sounds:
		if not has_node(audio_name):
			continue
		
		var roll = randf() * 100.0
		var chance = audio_chances[audio_name]
		
		# Roll berhasil, mainkan suara ini
		if roll <= chance:
			var audio = get_node(audio_name)
			
			if audio.playing:
				continue
			
			audio.pitch_scale = randf_range(0.8, 1.0)
			audio.volume_db = randf_range(-15.0, -5.0)
			
			var random_offset = Vector2(
				randf_range(-150, 150), 
				randf_range(-150, 150)
			)
			audio.global_position = player.global_position + random_offset
			
			audio.play()
			
			# >>> HANYA 1 SUARA, LANGSUNG RETURN
			return

func force_disturbance():
	play_random_disturbance()
