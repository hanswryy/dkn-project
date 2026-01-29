extends CharacterBody2D

var Tile_map : TileMap
var Astar : AStarGrid2D
var current_path_id: Array[Vector2i]
var speed := 50

var last_frame : int = -1
var target_item : Area2D = null
var target_tile_type : String = "" 

func _ready():
	Tile_map = get_parent().find_child("TileMap")
	Astar = Tile_map.AstarGrid
	
	print("\n[ASTAR INITIALIZATION]")
	update_astar_obstacles()
	
# move to spesific coord
func get_coord_to_pos(target_pos: Vector2):
	var start_point = Tile_map.local_to_map(global_position)
	#print("start_point" + str(start_point))
	var end_point = Tile_map.local_to_map(target_pos)
	#print("end_point: " + str(end_point))
	current_path_id = Astar.get_id_path(start_point, end_point).slice(1)
	print("current_path_id: " + str(current_path_id))


func update_astar_obstacles():
	var region = Tile_map.get_used_rect()
	var solid_count = 0
	var total_layers = Tile_map.get_layers_count()
	
	for x in range(region.position.x, region.end.x):
		for y in range(region.position.y, region.end.y):
			var pos = Vector2i(x, y)
			for layer_index in range(total_layers):
				var data = Tile_map.get_cell_tile_data(layer_index, pos)
				if data and data.get_collision_polygons_count(0) > 0:
					Astar.set_point_solid(pos, true)
					solid_count += 1
					break 
					
	Astar.update()
	print(">> Scanning ", total_layers, " layers...")
	print(">> Total Solid Tiles Found: ", solid_count)
	print(">> Map Region: ", region)

func _unhandled_input(event):
	if event.is_action_pressed("left_mbutton") and not PauseGameController.is_in_pause_box:
		var mouse_pos = get_global_mouse_position()
		var mouse_map_pos = Tile_map.local_to_map(mouse_pos)
		
		print("\n--- NEW INPUT DETECTED ---")
		
		if target_item == null:
			target_tile_type = "" 
			
			for i in Tile_map.get_layers_count():
				var tile_data = Tile_map.get_cell_tile_data(i, mouse_map_pos)
				if tile_data:
					var type = tile_data.get_custom_data("interact_type")
					
					if type != null and type is String and type != "":
						target_tile_type = type
						print(">> Found Interaction: '", type, "' on Layer ", i)
						break 
		else:
			print(">> Target is Physical Item (Area2D): ", target_item.name)

		var final_target = mouse_map_pos
		if Astar.is_point_solid(mouse_map_pos):
			print(">> Target is SOLID. Finding nearest walkable tile...")
			final_target = find_closest_walkable_cell(mouse_map_pos)
			
		calculate_path(final_target)

func find_closest_walkable_cell(target_cell: Vector2i) -> Vector2i:
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	for dir in directions:
		var neighbor = target_cell + dir
		if Astar.is_in_boundsv(neighbor) and not Astar.is_point_solid(neighbor):
			return neighbor
	return target_cell

func calculate_path(end_point: Vector2i):
	var start_point = Tile_map.local_to_map(global_position)
	current_path_id = Astar.get_id_path(start_point, end_point).slice(1)
	
	print(">> START POS: ", start_point)
	print(">> END POS: ", end_point)
	
	if current_path_id.is_empty():
		print(">> PATH: [NO PATH FOUND OR ALREADY AT DESTINATION]")
	else:
		print(">> PATH CALCULATED (", current_path_id.size(), " steps):")
		# Print rute per koordinat grid
		var path_string = ""
		for step in current_path_id:
			path_string += str(step) + " -> "
		print("   " + path_string + "FINISH")

func _process(delta):
	if current_path_id.is_empty():
		if last_frame != -2: 
			stop_moving()
			check_interactions()
			last_frame = -2
		return
		
	var target_pos = Tile_map.map_to_local(current_path_id[0])

	if global_position.distance_to(target_pos) < 5:
		current_path_id.pop_front()
		if current_path_id.is_empty():
			print("OI OI OI, BAAKAA")
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
		target_pos = Tile_map.map_to_local(current_path_id[0])

	move_playerTo(target_pos, delta)

func move_playerTo(target, _delta):
	var direction = (target - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if abs(direction.x) > abs(direction.y):
		$AnimatedSprite2D.play("w_right" if direction.x > 0 else "w_left")
	else:
		$AnimatedSprite2D.play("w_down" if direction.y > 0 else "w_up")
	play_footstep_sound()

func stop_moving():
	$AnimatedSprite2D.stop()
	$Langkah.stop()

func check_interactions():
	if target_tile_type != "":
		var mouse_pos = get_global_mouse_position()
		var dist = global_position.distance_to(mouse_pos)
		print("--- CHECKING INTERACTION ---")
		print(">> Target Type: ", target_tile_type)
		print(">> Final Distance to Mouse: ", dist)
		
		if dist < 60:
			execute_tile_interaction(target_tile_type)
		else:
			print(">> RESULT: FAILED (Too far away. Distance must be < 60)")
		
		target_tile_type = ""

func execute_tile_interaction(type: String):
	print(">> RESULT: SUCCESS! Signal Emitted for: ", type)
	match type:
		"Cangkir": SignalManager.cangkir_interaction_requested.emit()
		"Laci": SignalManager.drawer_interaction_requested.emit()
		"Padlock": SignalManager.padlock_interaction_requested.emit()
		"Foto": SignalManager.foto_interaction_requested.emit()
		"Bathtub": SignalManager.bathtub_interaction_requested.emit()

func play_footstep_sound():
	var current_frame = $AnimatedSprite2D.frame
	if current_frame != last_frame:
		if current_frame == 1 or current_frame == 3:
			$Langkah.play()
		last_frame = current_frame
