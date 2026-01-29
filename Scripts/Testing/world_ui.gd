extends CanvasLayer

@onready var inventory_ui = $InventoryUI
@onready var inv_button = %InventoryButton
@onready var fade_overlay = %FadeOverlay

@export var icon_open : Texture2D
@export var icon_close : Texture2D
@export var butterfly_key : ItemData
@export var basement_key : ItemData

var original_pos_y: float

func _ready():
	inventory_ui.visible = false
	InventoryManager.magnification_started.connect(start_magnify)
	SignalManager.monodialog_finished.connect(_on_clue_revealed)
	SignalManager.painting_interaction_requested.connect(_on_request_painting)
	SignalManager.eddie_drawer_interaction_requested.connect(_on_request_basement_key)
	SignalManager.highlight_closed_2.connect(_on_highlight_closed)
	
	original_pos_y = 653.0
	
func _on_highlight_closed(item_id: String):
	print(item_id)
	# Gunakan match untuk mengecek item_id
	match item_id:
		"clue_botol_racun":
			%MonodialogEventTrigger.start_monodialog("50")
		
		"clue_tisu":
			%MonodialogEventTrigger.start_monodialog("140")
			
		"clue_cangkir_revealed":
			%MonodialogEventTrigger.start_monodialog("60")
			
		"item_kaca_pembesar":
			%MonodialogEventTrigger.start_monodialog("70")
			
		"clue_surat_wasiat_palsu":
			%MonodialogEventTrigger.start_monodialog("80")
			
		"clue_surat_sita_bank":
			%MonodialogEventTrigger.start_monodialog("90")
			
		"clue_kunci_basement":
			%MonodialogEventTrigger.start_monodialog("100")
			
		"clue_kunci_kupu":
			%MonodialogEventTrigger.start_monodialog("100")
			
		"clue_tiket_kereta":
			%MonodialogEventTrigger.start_monodialog("115")
			
		"clue_obat_penenang":
			%MonodialogEventTrigger.start_monodialog("120")
			
		"clue_diary_lily":
			%MonodialogEventTrigger.start_monodialog("125")	
			
		"clue_jam_rusak":
			%MonodialogEventTrigger.start_monodialog("130")	
		
		_:
			print("Item ", item_id, " tidak memiliki dialog post-reveal.")
	
func _on_request_basement_key():
	print("ANJAY")
	if InventoryManager.has_item_by_id("clue_kunci_kupu"):
		print("ANJAY2asdasd")
		$PickupSFX.play()
		InventoryManager.add_item(basement_key)
		InventoryManager.item_highlight_requested.emit(basement_key)
	
func _on_request_painting():
	if InventoryManager.has_item_by_id("item_kaca_pembesar"):
		$PickupSFX.play()
		InventoryManager.add_item(butterfly_key)
		InventoryManager.item_highlight_requested.emit(butterfly_key)

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
	$MonodialogEventTrigger.start_monodialog(branch_id_to_play)

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
