extends CanvasLayer

@onready var inventory_ui = $InventoryUI
@onready var inv_button = %InventoryButton
@onready var fade_overlay = %FadeOverlay

@export var icon_open : Texture2D
@export var icon_close : Texture2D

var original_pos_y: float

func _ready():
	inventory_ui.visible = false
	InventoryManager.magnification_started.connect(start_magnify)
	SignalManager.monodialog_finished.connect(_on_clue_revealed)
	
	original_pos_y = 653.0

func start_magnify():
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# get branch_id
	var branch_id_to_play = 0
	if inventory_ui.selected_slot and inventory_ui.selected_slot.current_item_data:
		branch_id_to_play = inventory_ui.selected_slot.current_item_data.postRevealDialog
	
	# Fade In
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 2)
	await tween.finished
	
	toggle_inventory()
	await get_tree().create_timer(1.5).timeout
	
	# Fade Out
	var tween_out = create_tween()
	tween_out.tween_property(fade_overlay, "modulate:a", 0.0, 2)
	await tween_out.finished
	
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Monodialog
	%MonodialogEventTrigger.start_monodialog(branch_id_to_play)

func _unhandled_input(event):
	if event.is_action_pressed("open_inventory"):
		toggle_inventory()
	if (event.is_action_pressed("ui_cancel") && inventory_ui.visible):
		toggle_inventory()

func toggle_inventory():
	inventory_ui.visible = !inventory_ui.visible
	
	if inventory_ui.visible:
		%OpenInventorySFX.play()
		# refresh data item
		inventory_ui.fill_grid()
		get_tree().paused = true
		inv_button.icon = icon_open
	else:
		%CloseInventorySFX.play()
		get_tree().paused = false
		inv_button.icon = icon_close
		pass

func _on_inventory_button_pressed():
	toggle_inventory()

# show alert popup after dialog end to alert player that the clue has been updated
func _on_clue_revealed(branch_id, branch_type):
	if branch_type == "revealing_clue":
		show_alert()

func show_alert():
	await get_tree().create_timer(1).timeout
	
	var popup = %AlertPopup
	
	popup.position.y = original_pos_y + 30
	popup.modulate.a = 0
	popup.show()
	
	# pop in
	var tween_in = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween_in.tween_property(popup, "modulate:a", 1.0, 0.5)
	tween_in.tween_property(popup, "position:y", original_pos_y, 0.6)
	
	await get_tree().create_timer(2.5).timeout
	
	# 4. pop out
	var tween_out = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween_out.tween_property(popup, "modulate:a", 0.0, 0.5)
	tween_out.tween_property(popup, "position:y", original_pos_y + 30, 0.6)
	
	await tween_out.finished
	popup.hide()
	
	popup.position.y = original_pos_y
