#Player.gd
extends CharacterBody2D

@export var speed := 200.0

func _physics_process(delta):
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()

func _on_enemy_player_hit(player):
	print("Player was hit by enemy:", player.name)
