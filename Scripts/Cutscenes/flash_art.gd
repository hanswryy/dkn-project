extends Button

@export var bounce_speed: float = 4.0   # How fast it bounces
@export var bounce_distance: float = 10.0 # How far it moves (pixels)

var is_can_proceed = true
var picture_index = 0
@export var is_bad_ending = false

# We store the "base" position so we don't drift away
var _start_x: float

func bad_ending():
	$"../Control/TextureRect".texture = load("uid://bg3mr7m4pk7ur")
	$"../Control/TextureRect2".texture = load("uid://d1d85gryl1p3o")
	$"../Control/TextureRect3".texture = load("uid://yos6c6ckj4cq")
	$"../Control/Label".text = "Mereka memiliki hal yang kubutuhkan, dan Meski kakak sudah meminta bantuanmu, kau tetap tidak membantuku ketika aku benar-benar membutuhkannya. Aku hanya menginginkan Hak milikku. Mengapa?"
	$"../Control/Label2".text = "ini Tidak akan sakit, Matt. Kau tidak akan merasakan apa-apa. Ini adalah bayaran untuk masa depan yang sudah kau rampas dariku."
	$"../Control/Label3".text = "... dimana ini? disini gelap dan aku tidak bisa bergerak, Basement ... ? Eddie...? EDDIE! Nyalakan lampunya! Kenapa aku tidak bisa bangun?! Apa yang kau lakukan padaku?! Nyalakan lampunya dan lepaskan semua ini"

func good_ending():
	$"../Control/TextureRect".texture = load("uid://cbepq036mevft")
	$"../Control/TextureRect2".texture = load("uid://bgnlveijtftqv")
	$"../Control/TextureRect3".texture = load("uid://diykisqdtoatp")
	$"../Control/Label".text = "Kami memulainya dari serbuk kayu dan mimpi. Kami bermimpi untuk sukses bersama."
	$"../Control/Label2".text = "Tapi saat dia menatapku untuk terakhir kalinya… aku berpaling."
	$"../Control/Label3".text = "kau tahu Jilly? meski Aku tidak bisa menyelamatkan nyawanya. Tapi aku bisa membalaskan kematiannya. Dan aku tidak dapat melupakan dosa ini."

func _ready() -> void:
	if is_bad_ending:
		bad_ending()
	else:
		good_ending()
	
	var tween = create_tween()
	tween.tween_property($"../Control/TextureRect", "modulate:a", 1.0, 1.5) # fade in over 1.5 seconds
	
	# Remember where we started
	_start_x = position.x

	# CRITICAL IF IN A CONTAINER (VBox/HBox):
	# Containers constantly reset 'position'. We must connect to the 
	# 'sort_children' signal of the parent or simply update base x on resize.
	if get_parent() is Container:
		get_parent().sort_children.connect(_update_start_pos)

func _update_start_pos():
	# If the layout changes, update our reference point
	_start_x = position.x

func _process(delta: float) -> void:
	# Use time to create a wave between -1 and 1
	var time = Time.get_ticks_msec() / 1000.0
	var movement = sin(time * bounce_speed) * bounce_distance
	
	# Apply the movement
	position.x = _start_x + movement

func _on_pressed() -> void:
	$SFX_Click.play()
	if is_can_proceed and picture_index == 0:
		picture_index += 1
		$"../Control/TextureRect".visible = false
		$"../Control/Label".visible = false
		$"../Control/Label2".visible = true
		var tween = create_tween()
		is_can_proceed = false
		tween.tween_property($"../Control/TextureRect2", "modulate:a", 1.0, 1.5) # fade in over 1.5 seconds
		await tween.finished
		is_can_proceed = true
	elif is_can_proceed and picture_index == 1:
		picture_index += 1
		$"../Control/TextureRect2".visible = false
		$"../Control/Label2".visible = false
		$"../Control/Label3".visible = true
		var tween = create_tween()
		is_can_proceed = false
		tween.tween_property($"../Control/TextureRect3", "modulate:a", 1.0, 1.5) # fade in over 1.5 seconds
		await tween.finished
		is_can_proceed = true
	elif is_can_proceed and picture_index == 2:
		visible = false
		FadeToBlack_Transition.fade_to_scene("uid://cxteef3x40qsy", 4)
