#Pumpkin.gd
extends Area2D

signal goal_reached

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("goal_reached")
		print("Goal reached!")
