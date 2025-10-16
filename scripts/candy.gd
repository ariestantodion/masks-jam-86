#Candy.gd
extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		MaskManager.add_candy(1)
		queue_free()
