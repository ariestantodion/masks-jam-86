#Door.gd
extends Area2D

signal door_knocked

func _on_Door_body_entered(body):
	if body.name == "Player":
		emit_signal("door_knocked")
