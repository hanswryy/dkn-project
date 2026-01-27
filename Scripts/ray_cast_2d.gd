# raycast_controller.gd (attach ke RayCast2D)
extends RayCast2D

func _ready():
	enabled = true

func check_collision() -> bool:
	force_raycast_update()
	return is_colliding()
