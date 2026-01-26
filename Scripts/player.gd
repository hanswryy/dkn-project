extends CharacterBody2D

var Tile_map : TileMap
var Astar : AStarGrid2D
var current_path_id: Array[Vector2i]
var speed := 50

var last_frame : int = -1

var target_item : Area2D = null

func _ready():
	Tile_map = get_parent().find_child("TileMap")
	print("Hasil cari TileMap: ", Tile_map)
	Astar = Tile_map.AstarGrid

func _input(event):
	if event.is_action_pressed("left_mbutton") and not PauseGameController.is_in_pause_box:
		target_item = null
		get_coord()

# move to spesific coord
func get_coord_to_pos(target_pos: Vector2):
	var start_point = Tile_map.local_to_map(global_position)
	print("start_point" + str(start_point))
	var end_point = Tile_map.local_to_map(target_pos)
	print("end_point: " + str(end_point))
	current_path_id = Astar.get_id_path(start_point, end_point).slice(1)
	print("current_path_id: " + str(current_path_id))

func get_coord():
	var start_point = Tile_map.local_to_map(global_position)
	var end_point   = Tile_map.local_to_map(get_global_mouse_position())
	current_path_id = Astar.get_id_path(start_point, end_point).slice(1)

func _process(delta):
	if (Input.is_action_just_pressed("ui_down")):
		die()
	
	if current_path_id.is_empty():
		$AnimatedSprite2D.stop()
		$Langkah.stop()
		last_frame = -1
		
		# pickup the item when arrived at destination
		if target_item != null:
			print("Distance: " + str(global_position.distance_to(target_item.global_position)))
			if global_position.distance_to(target_item.global_position) < 32:
				target_item.pick_up()
				target_item = null
		return

	var target_pos = Tile_map.map_to_local(current_path_id[0])

	if global_position.distance_to(target_pos) < 2:
		current_path_id.pop_front()
		if current_path_id.is_empty():
			$AnimatedSprite2D.stop()
			$Langkah.stop()
			last_frame = -1
			return
		target_pos = Tile_map.map_to_local(current_path_id[0])

	move_playerTo(target_pos, delta)

func move_playerTo(target, delta):
	var direction = (target - global_position).normalized()
	global_position += direction * speed * delta
	move_and_slide()

	if abs(direction.x) > abs(direction.y):
		$AnimatedSprite2D.play("w_right" if direction.x > 0 else "w_left")
	else:
		$AnimatedSprite2D.play("w_down"  if direction.y > 0 else "w_up")
	
	play_footstep_sound()

func play_footstep_sound():
	var current_frame = $AnimatedSprite2D.frame
	
	if current_frame != last_frame:
		# >>> play suara di frame 1 dan 3
		if current_frame == 1 or current_frame == 3:
			$Langkah.play()
		
		last_frame = current_frame

func die():
	current_path_id.clear()
	$AnimatedSprite2D.stop()
	$Langkah.stop()
	last_frame = -1
	respawn()

func respawn():
	if CheckpointState.has_checkpoint:
		global_position = CheckpointState.checkpoint_position
	else:
		global_position = Vector2.ZERO
