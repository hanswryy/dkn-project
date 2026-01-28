extends TileMap

var AstarGrid: AStarGrid2D
@onready var objects_layer: TileMapLayer = $Objects

func _ready():
	assigning_astar()

func assigning_astar():
	var used_rect = get_used_rect()
	AstarGrid = AStarGrid2D.new()
	AstarGrid.region = used_rect
	AstarGrid.cell_size = tile_set.tile_size
	AstarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	AstarGrid.update()

# setting layer for the player if it walkable or not
	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var cell = Vector2i(x + used_rect.position.x, y + used_rect.position.y)

			# 1. Non-walkable environment (walls)
			var env_data = get_cell_tile_data(1, cell)
			if env_data and env_data.get_custom_data("Walkable") == false:
				AstarGrid.set_point_solid(cell)
				continue   # no need to check objects

			# 2. Objects that block movement
			var obj_data = objects_layer.get_cell_tile_data(cell)
			if obj_data and obj_data.get_custom_data("blocks_movement"):
				print("1")
				AstarGrid.set_point_solid(cell)
				
func get_interaction_cell(object_cell: Vector2i, player_global_pos: Vector2) -> Vector2i:
	var neighbors := [
		Vector2i.LEFT,
		Vector2i.RIGHT,
		Vector2i.UP,
		Vector2i.DOWN
	]

	var best_cell := object_cell
	var best_dist := INF

	for offset in neighbors:
		var cell: Vector2i = object_cell + offset

		if not AstarGrid.region.has_point(cell):
			continue

		if AstarGrid.is_point_solid(cell):
			continue

		var world_pos := map_to_local(cell)
		var dist := world_pos.distance_to(player_global_pos)

		if dist < best_dist:
			best_dist = dist
			best_cell = cell
			
	return best_cell

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
