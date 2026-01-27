extends Camera2D

@export var follow_speed := 8.0      # kecepatan follow (semakin besar = semakin "dekat")
@export var max_distance := 20.0     # jarak maksimum sebelum camera mulai follow (opsional)

var target: Node2D = null            # reference ke Player

func _ready():
	# Cari Player di scene (atau drag Player ke Inspector)
	target = get_parent()              # jika Camera2D child langsung Player
	if not target:
		target = get_tree().current_scene.find_child("Player", true, false)
	
	if target:
		global_position = target.global_position  # awal di posisi player
	else:
		push_warning("Player tidak ditemukan!")

func _process(delta):
	if not target:
		return
	
	# Smooth follow (Lerp) → terasa "dekat" karena cepat
	var target_pos = target.global_position
	global_position = lerp(global_position, target_pos, follow_speed * delta)
