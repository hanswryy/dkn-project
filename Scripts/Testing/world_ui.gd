extends CanvasLayer

@onready var inventory_ui = $InventoryUI
@onready var inv_button = %InventoryButton
@onready var fade_overlay = %FadeOverlay # Pastikan path-nya benar

@export var icon_open : Texture2D
@export var icon_close : Texture2D

func _ready():
	inventory_ui.visible = false
	InventoryManager.magnification_started.connect(start_magnify)

func start_magnify():
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
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
