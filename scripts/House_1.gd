extends Node2D

func _on_pumpkin_goal_reached():
	get_tree().change_scene_to_file("res://scenes/Street_2.tscn")
