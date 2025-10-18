#InvisibilityUI.gd
extends Control

@onready var status: Label = $StatusLabel
var player: Node = null

func _ready() -> void:
	# Find the Player node (must be in the "player" group)
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("No player found for InvisibilityUI")
		return

	# Wait one frame to let Player._ready() finish creating timers
	await get_tree().process_frame

	# Connect to player timers safely
	if player.has_node("_invis_timer"):
		player._invis_timer.timeout.connect(_on_invis_end)
	if player.has_node("_cooldown_timer"):
		player._cooldown_timer.timeout.connect(_on_cooldown_end)

	# Initialize label
	_update_label("Ready (Space)")

func _process(_delta: float) -> void:
	if not player:
		return

	if player.is_invisible and player._invis_timer:
		_update_label("Invisible (%.1fs left)" % player._invis_timer.time_left)
	elif player.on_cooldown and player._cooldown_timer:
		_update_label("Cooldown: %.1fs" % player._cooldown_timer.time_left)
	else:
		_update_label("Ready (Space)")

func _on_invis_end() -> void:
	_update_label("Cooldown…")

func _on_cooldown_end() -> void:
	_update_label("Ready (Space)")

func _on_level_change(_lvl: int) -> void:
	_update_label("Level up!")

func _update_label(text: String) -> void:
	status.text = text
