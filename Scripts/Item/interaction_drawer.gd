extends Control

@onready var texture_laci_closed = $PanelContainer/TextureLaciClosed
@onready var texture_buku = $PanelContainer/TextureLaciOpened/TextureBuku
@onready var book_area = $PanelContainer/TextureLaciOpened/ClickableAreaBook

@export var book_data: ItemData

func _ready():
	reset_drawer()
	SignalManager.drawer_interaction_requested.connect(_on_interaction_requested)

func reset_drawer():
	texture_laci_closed.show()
	#texture_buku.show()
	#book_area.show()

func _on_interaction_requested():
	if InventoryManager.has_item_by_id(book_data.id):
		print("Item ", book_data.name, " sudah ada di tas. Menghapus dari map.")
		%TextureBuku.hide()
		%ClickableAreaBook.hide()
	reset_drawer()
	show()

func _on_clickable_area_open_drawer_pressed() -> void:
	%PickupSFX.play()
	texture_laci_closed.hide()

func _on_clickable_area_book_pressed() -> void:
	%PickupSFX.play()
	InventoryManager.add_item(book_data)
	
	var tween = create_tween()
	tween.tween_property(texture_buku, "modulate:a", 0.0, 0.2)
	await tween.finished
	
	texture_buku.hide()
	book_area.hide()
	
	InventoryManager.item_highlight_requested.emit(book_data)
	
func _on_button_close_pressed() -> void:
	hide()
