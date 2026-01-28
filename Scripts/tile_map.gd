extends TileMap

var AstarGrid: AStarGrid2D

func _ready() -> void:
	assigning_astar()

func assigning_astar() -> void:
	var used_rect := get_used_rect()
	if used_rect.size == Vector2i.ZERO:
		return 

	AstarGrid = AStarGrid2D.new()
	AstarGrid.region = used_rect
	AstarGrid.cell_size = tile_set.tile_size
	AstarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	AstarGrid.update() # Inisialisasi awal

	# 1. Tandai SEMUA cell di dalam region sebagai solid terlebih dahulu
	for x in range(used_rect.position.x, used_rect.end.x):
		for y in range(used_rect.position.y, used_rect.end.y):
			AstarGrid.set_point_solid(Vector2i(x, y), true)

	# 2. Buka (set solid = false) hanya untuk cell yang ada di layer "jalan"
	# Anggaplah layer jalan adalah Layer 0 di TileMap
	var road_layer = 0 
	
	for x in range(used_rect.position.x, used_rect.end.x):
		for y in range(used_rect.position.y, used_rect.end.y):
			var tile_position = Vector2i(x, y)
			var tile_data = get_cell_tile_data(road_layer, tile_position)
			
			# Jika ada tile di layer jalan, maka titik ini BISA dilewati
			if tile_data != null:
				AstarGrid.set_point_solid(tile_position, false)

	AstarGrid.update()


func _on_door_body_entered(body):
	pass # Replace with function body.
