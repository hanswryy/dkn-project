extends Control

@onready var foto_depan = $PanelContainer/FotoDepan
@onready var clickable_area = $ClickableArea

func _ready():
	foto_depan.show()
	SignalManager.foto_interaction_requested.connect(_on_interaction_requested)
		
func _on_clickable_area_pressed() -> void:
	%PickupSFX.play()
	
	foto_depan.visible = !foto_depan.visible
	
	if foto_depan.visible:
		print("Melihat Foto Depan")
	else:
		print("Melihat Foto Belakang")
	
func _on_interaction_requested():
	show()
	
func _on_button_close_pressed() -> void:
	hide()
