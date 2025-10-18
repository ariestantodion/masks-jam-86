extends Control

@onready var status: Label = $StatusLabel
@onready var bar: ProgressBar = $CooldownBar
var player: Node = null

# --- Colors for each state ---
const COLOR_READY := Color(0.4, 1.0, 0.4)   # green
const COLOR_ACTIVE := Color(0.3, 0.6, 1.0)  # blue
const COLOR_COOLDOWN := Color(0.5, 0.5, 0.5) # gray

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("No player found for InvisibilityUI")
		return

	await get_tree().process_frame

	if player._invis_timer:
		player._invis_timer.timeout.connect(_on_invis_end)
	if player._cooldown_timer:
		player._cooldown_timer.timeout.connect(_on_cooldown_end)

	bar.value = 1.0
	_set_bar_color(COLOR_READY)
	_update_label("Ready (Space)")

func _process(_delta: float) -> void:
	if not player:
		return

	if player.is_invisible and player._invis_timer:
		var left : float = player._invis_timer.time_left
		var total : float = player._invis_timer.wait_time
		bar.value = clamp(1.0 - (left / total), 0.0, 1.0)
		_set_bar_color(COLOR_ACTIVE)
		_update_label("Invisible (%.1fs)" % left)

	elif player.on_cooldown and player._cooldown_timer:
		var left : float = player._cooldown_timer.time_left
		var total : float = player._cooldown_timer.wait_time
		bar.value = clamp((total - left) / total, 0.0, 1.0)
		_set_bar_color(COLOR_COOLDOWN)
		_update_label("Cooldown: %.1fs" % left)

	else:
		bar.value = 1.0
		_set_bar_color(COLOR_READY)
		_update_label("Ready (Space)")

func _on_invis_end() -> void:
	_set_bar_color(COLOR_COOLDOWN)
	_update_label("Cooldown…")

func _on_cooldown_end() -> void:
	bar.value = 1.0
	_set_bar_color(COLOR_READY)
	_update_label("Ready (Space)")

	var t = create_tween()
	t.tween_property(bar, "scale", Vector2(1.1, 1.1), 0.1)
	t.tween_property(bar, "scale", Vector2.ONE, 0.1)

func _on_level_change(_lvl: int) -> void:
	_update_label("Level up!")

func _update_label(text: String) -> void:
	status.text = text

func _set_bar_color(color: Color) -> void:
	bar.modulate = color
