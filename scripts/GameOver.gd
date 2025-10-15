#GameOver
extends Control

@onready var retry_button = $Button_Retry
@onready var quit_button = $Button_Quit

func _ready():
	retry_button.pressed.connect(_on_retry_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_retry_pressed():
	# Go back to street to start fresh
	get_tree().change_scene_to_file("res://scenes/Street.tscn")

func _on_quit_pressed():
	get_tree().quit()
