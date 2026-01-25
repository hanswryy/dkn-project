extends Area2D

signal activated(position: Vector2)

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("activated", global_position)

func _on_body_exited(body):
	if body.is_in_group("player"):
		queue_free()
