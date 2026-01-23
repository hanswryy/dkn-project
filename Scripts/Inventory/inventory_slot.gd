extends PanelContainer

@onready var icon = $Icon

func display_item(item_data: ItemData):
	if item_data:
		icon.texture = item_data.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false
