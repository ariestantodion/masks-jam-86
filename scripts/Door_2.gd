#Door.gd
extends Area2D

#Track whether the player is close enough to interact
var player_nearby: bool = false

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false

func _process(delta):
	# Check if the player is nearby AND presses the interact key ("E")
	if player_nearby and Input.is_action_just_pressed("Interact"):
		get_tree().change_scene_to_file("res://scenes/House_2.tscn")
		print("Poop")
 
