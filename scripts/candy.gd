# Candy.gd
extends Area2D

signal collected

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("collected")
		queue_free()
