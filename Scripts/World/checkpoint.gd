extends Area2D

signal activated(position: Vector2)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("activated", global_position)
