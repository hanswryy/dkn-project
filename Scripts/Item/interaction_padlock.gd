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
	SignalManager.padlock_interaction_requested.connect(_on_interaction_requested)
	
func rotate_digit(index: int):
	current_code[index] = (current_code[index] + 1) % 10
	labels[index].text = str(current_code[index])
	
	%PutItemSFX.play()
	
	check_password()

func _on_interaction_requested():
	show()

func update_display():
	for i in range(4):
		labels[i].text = str(current_code[i])

func check_password():
	if current_code == correct_password:
		unlock_padlock()

func unlock_padlock():
	for label in labels:
		label.get_parent().mouse_filter = Control.MOUSE_FILTER_IGNORE 
	
	%UnlockedSFX.play()
	
	if item_inside:
		InventoryManager.add_item(item_inside)
		InventoryManager.item_highlight_requested.emit(item_inside)
		
		if !SignalManager.is_connected("highlight_closed", _on_highlight_finished):
			SignalManager.highlight_closed.connect(_on_highlight_finished, CONNECT_ONE_SHOT)
	else:
		_on_highlight_finished()

func _on_highlight_finished():
	print("Highlight finished")
	await run_full_transition()
	hide()
	SignalManager.padlock_unlocked.emit(item_inside)

func run_full_transition():
	# fade in
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween_in = create_tween()
	tween_in.tween_property(fade_overlay, "modulate:a", 1.0, 2)
	await tween_in.finished
	
	$PanelContainer.hide()
	await get_tree().create_timer(0.3).timeout
	
	# fade out
	var tween_out = create_tween()
	tween_out.tween_property(fade_overlay, "modulate:a", 0.0, 2)
	await tween_out.finished
	
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide()
	
func _on_slot_1_pressed(): rotate_digit(0)
func _on_slot_2_pressed(): rotate_digit(1)
func _on_slot_3_pressed(): rotate_digit(2)
func _on_slot_4_pressed(): rotate_digit(3)


func _on_button_pressed() -> void:
	hide()
