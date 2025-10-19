#Victory.gd
extends Control

@onready var play_again: Button = %PlayAgain
@onready var quit_btn: Button = %Quit

func _ready() -> void:
	play_again.pressed.connect(_on_play_again)
	quit_btn.pressed.connect(_on_quit)

func _on_play_again() -> void:
	MaskManager.house_progress = 0
	MaskManager.last_house_index = 1
	get_tree().change_scene_to_file("res://scenes/Street.tscn")

func _on_quit() -> void:
	get_tree().quit()
