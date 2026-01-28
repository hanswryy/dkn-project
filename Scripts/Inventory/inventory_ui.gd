extends Control

const SLOT_SCENE = preload(Constants.SCENE_PATHS.inventory_slot)

@onready var grid = %ItemGrid
@onready var info_icon = %ItemIcon
@onready var info_name = %ItemName
@onready var info_desc = %ItemDescription
@onready var detail_button = %DetailButton

var selected_slot: PanelContainer = null

func _ready():
	InventoryManager.inventory_updated.connect(fill_grid)
	fill_grid()
	
func _process(delta: float) -> void:
	if selected_slot != null && selected_slot.current_item_data != null && InventoryManager.has_magnifying_glass():
		# show button if the item is magnifiable
		if selected_slot.current_item_data.magnifiable:
			%MagnifyButton.show()
		else:
			%MagnifyButton.hide()
	else:
		%MagnifyButton.hide()

func fill_grid():
	# Clear grid
	for child in grid.get_children():
		child.queue_free()
	
	for i in range(InventoryManager.MAX_SLOTS):
		var new_slot = SLOT_SCENE.instantiate()
		grid.add_child(new_slot)
		
		# Item selected/clicked
		new_slot.slot_clicked.connect(_on_slot_clicked)
		
		if i < InventoryManager.items.size():
			new_slot.display_item(InventoryManager.items[i])
		else:
			new_slot.display_item(null)
			
func _on_slot_clicked(item_data: ItemData, slot_node: PanelContainer):
	if selected_slot != null:
		selected_slot.set_selected(false)
		
	selected_slot = slot_node
	selected_slot.set_selected(true)
		
	if item_data:
		info_name.text = item_data.name
		info_desc.text = item_data.description
		info_icon.texture = item_data.icon
		info_icon.visible = true
		detail_button.visible = item_data.hasDetail
	else:
		info_name.text = ""
		info_desc.text = ""
		info_icon.visible = false
		detail_button.visible = false


func _on_magnify_button_pressed() -> void:
	%MagnifySFX.play()
	InventoryManager.magnify_item(selected_slot.current_item_data)
