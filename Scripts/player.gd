extends CharacterBody2D

var Tile_map : TileMap
var Astar = AStarGrid2D
var current_path_id:Array[Vector2i]
var speed := 50

func _ready():
	Tile_map = get_parent().get_node("TileMap")
	Astar = Tile_map.AstarGrid

func _input(event):
	if event.is_action_pressed("left_mbutton"):
		get_coord()
		
func get_coord():
	var start_point = Tile_map.local_to_map(global_position)
	var end_point = Tile_map.local_to_map(get_global_mouse_position())
	current_path_id =  Astar.get_id_path(start_point, end_point).slice(1)

func _process(delta):
	if current_path_id.is_empty():
		return
	var target_pos = Tile_map.map_to_local(current_path_id[0])
	
	if global_position.distance_to(target_pos) < 2:
		current_path_id.pop_front()
		if current_path_id.is_empty():
			return
		target_pos = Tile_map.map_to_local(current_path_id[0])
		
	move_playerTo(target_pos, delta)
	

func move_playerTo(target, delta):
	var direction = (target - global_position).normalized()
	global_position += direction * speed * delta
	move_and_slide()
