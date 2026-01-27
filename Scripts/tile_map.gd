extends TileMap

var AstarGrid: AStarGrid2D

# Layer index sesuai struktur Anda
const WALKABLE_LAYER: int = 0      # Layer 0 = Walkable
const NON_WALKABLE_LAYER: int = 1  # Layer 1 = Non-Walkable  
const OBJECT_LAYER: int = 2        # Layer 2 = Object

func _ready():
	assigning_astar()

func assigning_astar():
	var used_rect = get_used_rect()
	AstarGrid = AStarGrid2D.new()
	AstarGrid.region = used_rect
	AstarGrid.cell_size = tile_set.tile_size
	AstarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	AstarGrid.update()

	# Scan semua tile di region
	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var tile_position = Vector2i(x + used_rect.position.x, y + used_rect.position.y)
			
			# Cek apakah tile ini blocked
			if is_tile_blocked(tile_position):
				AstarGrid.set_point_solid(tile_position)

func is_tile_blocked(pos: Vector2i) -> bool:
	# Layer 1 (Non-Walkable) ada tile?
	if get_cell_source_id(NON_WALKABLE_LAYER, pos) != -1:
		return true
	
	# Layer 2 (Object) ada tile?
	if get_cell_source_id(OBJECT_LAYER, pos) != -1:
		return true
	
	# Layer 0 (Walkable) kosong?
	if get_cell_source_id(WALKABLE_LAYER, pos) == -1:
		return true  # Void = blocked
	
	return false

# >>> FITUR TAMBAHAN: Update solid tile saat runtime (object dipindah/dihancurkan)
func set_tile_solid(pos: Vector2i, solid: bool):
	if solid:
		AstarGrid.set_point_solid(pos)
	else:
		AstarGrid.set_point_solid(pos, false)

# >>> FITUR TAMBAHAN: Cari tile walkable terdekat jika klik di object
func find_nearest_walkable(from_pos: Vector2i, max_radius: int = 3) -> Vector2i:
	for radius in range(1, max_radius + 1):
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				var check_pos = from_pos + Vector2i(x, y)
				if not is_tile_blocked(check_pos):
					return check_pos
	return Vector2i(-1, -1)

# >>> FITUR TAMBAHAN: Path finder dengan validasi
func get_path_with_validation(start_world: Vector2, end_world: Vector2) -> Array[Vector2i]:
	var start_map = local_to_map(start_world)
	var end_map = local_to_map(end_world)
	
	# Jika klik di object/non-walkable, cari terdekat
	if is_tile_blocked(end_map):
		end_map = find_nearest_walkable(end_map)
		if end_map == Vector2i(-1, -1):
			return []  # Tidak ada walkable di sekitar
	
	return AstarGrid.get_id_path(start_map, end_map)
