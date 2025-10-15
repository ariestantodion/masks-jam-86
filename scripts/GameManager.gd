#GameManager.gd
extends Node

var lives: int = 3

func _ready():
	print("GameManager ready! Lives =", lives)

func on_player_hit():
	lives -= 1
	print("Player hit! Lives left:", lives)

	if lives > 0:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
		
func _process(delta):
	# TEMP: Press "H" to simulate getting hit
	if Input.is_action_just_pressed("ui_home"): # You can bind 'H' key to this in InputMap
		on_player_hit()
