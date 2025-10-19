#Door.gd
extends Area2D

@export_file("*.tscn") var target_house: String = ""
@export var house_index: int = 1
@export var requires_progress: bool = true

@onready var _sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var _label: Label = $HintLabel if has_node("HintLabel") else null
var _player_inside: bool = false

func _ready() -> void:
	_update_locked_visuals()

func _update_locked_visuals() -> void:
	var unlocked := not requires_progress or house_index <= MaskManager.house_progress + 1
	if _sprite:
		_sprite.modulate = Color(1,1,1,1) if unlocked else Color(0.7,0.7,0.7,0.85)
	if _label:
		_label.text = "Press [E] to enter" if unlocked else "Locked"

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = true
		if _label: _label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = false
		if _label: _label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not _player_inside:
		return
	if event.is_action_pressed("interact"):
		var unlocked := not requires_progress or house_index <= MaskManager.house_progress + 1
		if not unlocked:
			print("Door locked. Clear previous house first.")
			return
		if target_house != "":
			get_tree().change_scene_to_file(target_house)
