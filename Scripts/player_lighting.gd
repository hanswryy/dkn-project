extends PointLight2D

@export var base_energy := 1.0
@export var normal_flicker := 0.05
@export var burst_chance := 0.02
@export var burst_duration := 0.1
@export var burst_intensity := 2.0

@export var light_out_min_time := 60.0
@export var light_out_max_time := 180.0

@export var min_dark_duration := 3.0
@export var max_dark_duration := 5.0

@export var fade_in_duration := 0.5
@export var delay_between_sounds := 1.0  # >>> JEDA 1 DETIK ANTAR SUARA

var _burst_timer := 0.0
var _is_bursting := false

var _is_light_out := false
var _dark_timer := 0.0
var _korek_attempts := 0

var _light_out_timer := 0.0
var _is_fading_in := false
var _fade_in_timer := 0.0

var korek_sounds : Array[String] = ["Korek1x", "Korek2x", "Korek3x"]
const KOREK_FAIL := "Korek_fail"

func _ready():
	enabled = true
	_set_next_light_out()

func _set_next_light_out():
	_light_out_timer = randf_range(light_out_min_time, light_out_max_time)

func _process(delta):
	if _is_fading_in:
		_fade_in_timer -= delta
		var progress = 1.0 - (_fade_in_timer / fade_in_duration)
		energy = base_energy * clamp(progress, 0.0, 1.0)
		
		if _fade_in_timer <= 0:
			_is_fading_in = false
			energy = base_energy
		
		return
	
	if _is_light_out:
		_dark_timer -= delta
		energy = 0.0
		
		if _dark_timer <= 0:
			_attempt_light_on()
		
		return
	
	if _is_bursting:
		_burst_timer -= delta
		if _burst_timer <= 0:
			_is_bursting = false
		else:
			energy = randf_range(0.1, burst_intensity)
		return
	
	energy = base_energy + randf_range(-normal_flicker, normal_flicker)
	
	if randf() < burst_chance:
		_start_burst()
	
	_light_out_timer -= delta
	if _light_out_timer <= 0:
		_light_out()

func _start_burst():
	_is_bursting = true
	_burst_timer = burst_duration

func _light_out():
	_is_light_out = true
	_dark_timer = randf_range(min_dark_duration, max_dark_duration)
	_korek_attempts = 0
	
	enabled = false
	energy = 0.0

# >>> ASYNC: Bisa pakai await
func _attempt_light_on():
	_korek_attempts += 1
	
	var sound_name = korek_sounds[randi() % korek_sounds.size()]
	
	# >>> MAINKAN SUARA PERTAMA
	_play_korek_sound(sound_name)
	
	# >>> TUNGGU SUARA + JEDA 1 DETIK
	var audio_duration = _get_audio_duration(sound_name)
	await get_tree().create_timer(audio_duration + delay_between_sounds).timeout
	
	# >>> CEK BERHASIL ATAU GAGAL
	var success_roll = randf()
	var success_threshold = 0.7
	
	if _korek_attempts >= 2:
		success_threshold = 0.5
	if _korek_attempts >= 3:
		success_threshold = 0.3
	
	if success_roll <= success_threshold:
		_start_fade_in()
	else:
		# >>> MAINKAN KOREK_FAIL + JEDA
		_play_korek_sound(KOREK_FAIL)
		await get_tree().create_timer(_get_audio_duration(KOREK_FAIL) + delay_between_sounds).timeout
		
		_dark_timer = randf_range(1.0, 3.0)

func _get_audio_duration(sound_name: String) -> float:
	match sound_name:
		"Korek1x": return 0.3
		"Korek2x": return 0.5
		"Korek3x": return 0.7
		"Korek_fail": return 0.4
		_: return 0.5

func _start_fade_in():
	_is_light_out = false
	enabled = true
	_is_fading_in = true
	_fade_in_timer = fade_in_duration
	_korek_attempts = 0
	
	_set_next_light_out()

func _play_korek_sound(sound_name: String):
	if has_node(sound_name):
		var audio = get_node(sound_name)
		if not audio.playing:
			audio.pitch_scale = randf_range(0.95, 1.05)
			audio.play()
