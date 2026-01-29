extends Button

@export var bounce_speed: float = 4.0   # How fast it bounces
@export var bounce_distance: float = 10.0 # How far it moves (pixels)

var is_can_proceed = true
var picture_index = 0
var is_bad_ending = false

# We store the "base" position so we don't drift away
var _start_x: float

func bad_ending():
	$"../Control/TextureRect".texture = load("uid://bg3mr7m4pk7ur")
	$"../Control/TextureRect2".texture = load("uid://d1d85gryl1p3o")
	$"../Control/TextureRect3".texture = load("uid://yos6c6ckj4cq")
	$"../Control/Label".text = "jawa jawa jawa"
	$"../Control/Label2".text = "jawa jawa jawa"
	$"../Control/Label3".text = "jawa jawa jawa"

func good_ending():
	$"../Control/TextureRect".texture = load("uid://cbepq036mevft")
	$"../Control/TextureRect2".texture = load("uid://bgnlveijtftqv")
	$"../Control/TextureRect3".texture = load("uid://diykisqdtoatp")
	$"../Control/Label".text = "jawa jawa jawa"
	$"../Control/Label2".text = "jawa jawa jawa"
	$"../Control/Label3".text = "jawa jawa jawa"

func _ready() -> void:
	bad_ending()
	
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
		var tween = create_tween()
		is_can_proceed = false
		tween.tween_property($"../Control/TextureRect2", "modulate:a", 1.0, 1.5) # fade in over 1.5 seconds
		await tween.finished
		is_can_proceed = true
	elif is_can_proceed and picture_index == 1:
		picture_index += 1
		$"../Control/TextureRect2".visible = false
		var tween = create_tween()
		is_can_proceed = false
		tween.tween_property($"../Control/TextureRect3", "modulate:a", 1.0, 1.5) # fade in over 1.5 seconds
		await tween.finished
		is_can_proceed = true
	elif is_can_proceed and picture_index == 2 and not is_bad_ending:
		visible = false
		FadeToBlack_Transition.fade_to_scene("uid://cxteef3x40qsy", 4)
	elif is_can_proceed and picture_index == 2 and is_bad_ending:
		visible = false
		picture_index += 1
		$"../Control/TextureRect3".visible = false
		var tween = create_tween()
		is_can_proceed = false
		tween.tween_property($"../Control/TextureRect4", "modulate:a", 1.0, 1.5) # fade in over 1.5 seconds
		await tween.finished
		is_can_proceed = true
		FadeToBlack_Transition.fade_to_scene("uid://cxteef3x40qsy", 4)
