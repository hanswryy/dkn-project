extends Control

@export var correct_password : Array[int] = [1, 8, 1, 2]
@export var item_inside : ItemData

var current_code : Array[int] = [0, 0, 0, 0]

@onready var fade_overlay = $FadeOverlay
@onready var labels : Array[Label] = [
	$PanelContainer/TextureRect/Num1,
	$PanelContainer/TextureRect/Num2,
	$PanelContainer/TextureRect/Num3,
	$PanelContainer/TextureRect/Num4
]

func _ready():
	#hide()
	update_display()
	
func rotate_digit(index: int):
	current_code[index] = (current_code[index] + 1) % 10
	labels[index].text = str(current_code[index])
	
	%PutItemSFX.play()
	
	check_password()

func update_display():
	for i in range(4):
		labels[i].text = str(current_code[i])

func check_password():
	if current_code == correct_password:
		unlock_padlock()

func unlock_padlock():
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	#await get_tree().create_timer(0.7).timeout
	%UnlockedSFX.play()
	#await get_tree().create_timer(1).timeout
	#await fade_transition()
	
	# give item
	if item_inside:
		InventoryManager.add_item(item_inside)
		InventoryManager.item_highlight_requested.emit(item_inside)
	
	SignalManager.padlock_unlocked.emit(item_inside)
	#hide()
	#await get_tree().create_timer(0.5).timeout
	
func fade_transition():
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Fade In
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 2)
	await tween.finished
	
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _on_slot_1_pressed(): rotate_digit(0)
func _on_slot_2_pressed(): rotate_digit(1)
func _on_slot_3_pressed(): rotate_digit(2)
func _on_slot_4_pressed(): rotate_digit(3)
