#Pumpkin
extends Area2D

@export var house_index: int = 1
@export_file("*.tscn") var return_to_street: String = "res://scenes/Street.tscn"

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	MaskManager.mark_house_cleared(house_index)
	MaskManager.last_house_index = house_index
	if MaskManager.house_progress >= 3:
		get_tree().change_scene_to_file("res://scenes/Victory.tscn")
	else:
		get_tree().change_scene_to_file(return_to_street)
