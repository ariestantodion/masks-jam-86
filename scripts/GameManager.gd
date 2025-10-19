extends Node

signal lives_changed(value: int)

var lives: int = 3

func _ready():
	print("GameManager ready! Lives =", lives)
	lives_changed.emit(lives)  # emit initial value so UI starts correct

func on_player_hit():
	lives -= 1
	print("Player hit! Lives left:", lives)
	lives_changed.emit(lives)

	if lives > 0:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func _process(_delta: float) -> void:
	# TEMP: Press "H" to simulate getting hit
	if Input.is_action_just_pressed("ui_home"): # Bind 'H' key in InputMap
		on_player_hit()
