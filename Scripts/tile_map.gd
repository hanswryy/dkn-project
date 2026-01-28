extends TileMap

var AstarGrid: AStarGrid2D

func _ready() -> void:
	assigning_astar()

func assigning_astar() -> void:
	var used_rect := get_used_rect()
	if used_rect.size == Vector2i.ZERO:
		return          # <─ tidak usah buat AStarGrid kalau tidak ada tile

	# ===== buat & setup AStarGrid =====
	AstarGrid = AStarGrid2D.new()
	AstarGrid.region = used_rect
	AstarGrid.cell_size = tile_set.tile_size
	AstarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	# scan & mark solid
	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var tile_position = Vector2i(x + used_rect.position.x, y + used_rect.position.y)
			var tile_data = get_cell_tile_data(1, tile_position)
			if tile_data != null and not tile_data.get_custom_data("0"):  # <-- pakai nama layer "0"
				AstarGrid.set_point_solid(tile_position)

	AstarGrid.update()  # baru panggil setelah semua set_point_solid selesai
