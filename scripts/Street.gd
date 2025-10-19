#Street.gd
extends Node2D

@onready var player: Node2D = $Player
@onready var upgrade_menu: Control = $Player/UI/UpgradeMenu
@onready var prompt_label: Label = $Player/UI/PromptLabel

func _ready() -> void:
	# Place player in front of the correct door
	var idx := MaskManager.last_house_index + 1
	var spawn_name := "Spawn%d" % idx
	if has_node(spawn_name):
		var spawn := get_node(spawn_name)
		var player := get_tree().get_first_node_in_group("player")
		if player:
			player.global_position = spawn.global_position
	if not has_node(spawn_name):
		spawn_name = "Spawn1"  # fallback for first load

	prompt_label.visible = true
	prompt_label.text = "Press [U] to open Upgrade Menu"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("upgrade_menu"):
		_toggle_upgrade_menu()

func _toggle_upgrade_menu() -> void:
	if not upgrade_menu:
		print("⚠️ UpgradeMenu not found at $Player/UI/UpgradeMenu")
		return

	if upgrade_menu.visible:
		upgrade_menu.close_menu()   # ✅ correct function name
	else:
		upgrade_menu.open()
