#Street.gd
extends Node2D

func _ready() -> void:
	# Place player in front of the correct door
	var idx := MaskManager.last_house_index
	var spawn_name := "Spawn%d" % idx
	if has_node(spawn_name):
		var spawn := get_node(spawn_name)
		var player := get_tree().get_first_node_in_group("player")
		if player:
			player.global_position = spawn.global_position
