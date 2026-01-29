extends CharacterBody2D

var target: Node2D = null
var speed = 45

@onready var sprite := $Sprite2D
@onready var trigger := $JumpscareTrigger
@onready var collision_shape := $CollisionShape2D 

var audio_player: AudioStreamPlayer

# Simpan path scene saat ini agar entity tahu dia ada di level mana
# Kita ambil dari root scene yang sedang aktif
var current_scene_path: String

func _ready():
	# 1. Dapatkan Path Scene tempat Entity berada sekarang
	# (Misal: "res://Scenes/Level1.tscn")
	current_scene_path = get_tree().current_scene.scene_file_path
	
	# 2. Cek apakah Level ini SUDAH pernah jumpscare di Manager
	if JumpscareManager.is_triggered(current_scene_path):
		print("Level '", current_scene_path, "' sudah selesai jumpscare. Entity dihapus.")
		queue_free() # Hapus entity segera
		return # Jangan jalankan kode di bawah ini
	
	# 3. Jika belum, setup Entity normal
	target = get_tree().get_first_node_in_group("player")
	trigger.body_entered.connect(_on_jumpscare_trigger)
	
	# Setup Audio
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://Assets/Audio/BGM/BGM tegang.mp3")
	audio_player.name = "TenseMusic"
	add_child(audio_player) 
	audio_player.play()

func _physics_process(_delta):
	if not sprite.visible:                       
		return
	
	# Logic Looping Audio
	if audio_player and not audio_player.playing:
		audio_player.play()

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
