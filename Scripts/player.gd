extends CharacterBody2D

var Tile_map : TileMap
var Astar = AStarGrid2D
var current_path_id: Array[Vector2i]
var speed := 50      # pastikan anak langsung CharacterBody2D

signal arrived

var is_external_move := false
var external_target_cell: Vector2i


func _ready():
	Tile_map = get_parent().get_node("TileMap")
	Astar = Tile_map.AstarGrid

func _input(event):
	if is_external_move:
		return
	
	if event.is_action_pressed("left_mbutton") and not PauseGameController.is_in_pause_box:
		get_coord()

func get_coord():
	var start_point = Tile_map.local_to_map(global_position)
	var end_point   = Tile_map.local_to_map(get_global_mouse_position())
	current_path_id = Astar.get_id_path(start_point, end_point).slice(1)

func _process(delta):
	# Debug die logic
	if (Input.is_action_just_pressed("ui_down")):
		die()
	
	if current_path_id.is_empty():
		$AnimatedSprite2D.stop()          # diam saat tidak ada jalan
		
		if is_external_move:
			is_external_move = false
			emit_signal("arrived")
		return

	var target_pos = Tile_map.map_to_local(current_path_id[0])

	if global_position.distance_to(target_pos) < 2:
		current_path_id.pop_front()
		if current_path_id.is_empty():
			$AnimatedSprite2D.stop()
			return
		target_pos = Tile_map.map_to_local(current_path_id[0])

	move_playerTo(target_pos, delta)

func move_playerTo(target, delta):
	var direction = (target - global_position).normalized()
	global_position += direction * speed * delta
	move_and_slide()

	# >>> putar animasi sesuai arah
	if abs(direction.x) > abs(direction.y):      # dominan horizontal
		$AnimatedSprite2D.play("w_right" if direction.x > 0 else "w_left")
	else:                                        # dominan vertikal
		$AnimatedSprite2D.play("w_down"  if direction.y > 0 else "w_up")

func move_to_cell(cell: Vector2i):
	var start_point = Tile_map.local_to_map(global_position)
	external_target_cell = cell
	current_path_id = Astar.get_id_path(start_point, cell).slice(1)
	is_external_move = true	

func die():
	# Clear current path, making sure player doesnt move when they die while moving
	current_path_id.clear()
	respawn()

func respawn():
	if CheckpointState.has_checkpoint:
		global_position = CheckpointState.checkpoint_position
	else:
		global_position = Vector2.ZERO  # or start position
