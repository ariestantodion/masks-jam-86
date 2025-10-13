#Main.gd
extends Node2D

@onready var ui = $UI

func _ready():
	# Connect all candies' signals to this Main script
	var candies = get_tree().get_nodes_in_group("candies")
	for candy in candies:
		candy.connect("collected", Callable(self, "_on_candy_collected"))

func _on_candy_collected():
	ui.add_candy(1)

func _on_Door_door_knocked():
	print("Door knocked!")
