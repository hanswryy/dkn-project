extends PointLight2D

@export var base_energy := 1.0
@export var normal_flicker := 0.05
@export var burst_chance := 0.02          # 2% chance per frame
@export var burst_duration := 0.1
@export var burst_intensity := 2.0

var _burst_timer := 0.0
var _is_bursting := false

func _process(delta):
	if _is_bursting:
		_burst_timer -= delta
		if _burst_timer <= 0:
			_is_bursting = false
		else:
			# Burst: random tinggi-rendah cepat
			energy = randf_range(0.1, burst_intensity)
		return
	
	# Normal flicker
	energy = base_energy + randf_range(-normal_flicker, normal_flicker)
	
	# Random burst
	if randf() < burst_chance:
		_start_burst()

func _start_burst():
	_is_bursting = true
	_burst_timer = burst_duration
