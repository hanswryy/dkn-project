extends CharacterBody2D

@export var speed: float = 45.0

@onready var sprite := $Sprite2D
@onready var trigger := $JumpscareTrigger
@onready var collision_shape := $CollisionShape2D

var target: Node2D = null
var audio_player: AudioStreamPlayer
var current_scene_path: String

func _ready() -> void:
	# 1. Ambil path scene saat ini
	current_scene_path = get_tree().current_scene.scene_file_path
	
	# 2. LOGIKA BARU:
	# Jika 'jumpscare_hall_triggered' bernilai TRUE, artinya kejadian sudah lewat.
	# Maka hapus node ini agar hantu tidak muncul/mengejar lagi.
	if JumpscareManager.jumpscare_hall_triggered == true:
		print("Entity: Jumpscare hall sudah selesai. Menghapus diri.")
		queue_free()
		return
	
	# 3. Double Check (Opsional): Cek juga sistem path kalau kamu pakai sistem simpan scene
	if JumpscareManager.is_triggered(current_scene_path):
		queue_free()
		return
	
	# 4. Jika sampai sini, berarti flag masih FALSE. Setup entity untuk mengejar!
	target = get_tree().get_first_node_in_group("player")
	
	if not trigger.body_entered.is_connected(_on_jumpscare_trigger):
		trigger.body_entered.connect(_on_jumpscare_trigger)
	
	_setup_audio()

func _setup_audio() -> void:
	# Pastikan tidak membuat audio ganda
	if has_node("TenseMusic"): return
	
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://Assets/Audio/BGM/BGM tegang.mp3")
	audio_player.name = "TenseMusic"
	add_child(audio_player)
	audio_player.play()

func _physics_process(_delta: float) -> void:
	# Berhenti mengejar jika hantu sudah diproses untuk hilang
	if not sprite.visible:
		return
	
	# Pastikan audio looping
	if audio_player and not audio_player.playing:
		audio_player.play()

	# Pergerakan mengejar player
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		look_at(target.global_position)
		move_and_slide()

# ---------- Jumpscare ----------
func _on_jumpscare_trigger(body: Node2D) -> void:
	if body.is_in_group("player"):
		sprite.visible = false                 
		
		# Matikan Trigger & Kolisi (Gunakan set_deferred untuk menghindari error)
		trigger.set_deferred("monitoring", false)
		collision_shape.set_deferred("disabled", true)
		
		# --- INTEGRASI DENGAN MANAGER ---
		# Tandai scene ini sebagai "Sudah Jumpscare" di JumpscareManager
		JumpscareManager.mark_triggered(current_scene_path)
		print("Jumpscare terjadi di: ", current_scene_path)
		
		# Matikan Audio
		if audio_player:
			audio_player.stop()
			audio_player.queue_free()
