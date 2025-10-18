#Player.gd
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

# --- Base movement ---
@export var base_speed := 200.0
var speed := 200.0

# --- Toast (popup) UI reference ---
var toast: Node = null

# --- Invisibility system (Dion) ---
const BASE_INVIS_DURATION := 2.0
const BASE_INVIS_COOLDOWN := 5.0
const DURATION_PER_LEVEL := 0.5   # +0.5 s per level
const COOLDOWN_PER_LEVEL := 0.5   # −0.5 s per level (min 0.5 s)

var is_invisible: bool = false
var on_cooldown: bool = false
var _invis_timer: Timer
var _cooldown_timer: Timer
var _last_cooldown_total: float = 0.0


func _ready() -> void:
	print("MaskManager loaded:", MaskManager)
	print("Current candy:", MaskManager.candy)
	print(_get_invisibility_params())

	# Find the Toast node in the scene tree (group name = "toast")
	toast = get_tree().get_first_node_in_group("toast")

	# Apply initial speed & color
	_apply_speed()
	_apply_mask_tint()

	# Connect speed upgrade signal
	if not MaskManager.speed_upgraded.is_connected(_on_speed_upgraded):
		MaskManager.speed_upgraded.connect(_on_speed_upgraded)

	# --- Invisibility timers setup ---
	_invis_timer = Timer.new()
	_invis_timer.one_shot = true
	add_child(_invis_timer)
	_invis_timer.timeout.connect(_on_invisibility_timeout)

	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	add_child(_cooldown_timer)
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)


func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	move_and_slide()

	# Temporary upgrade hotkey (press U)
	if Input.is_action_just_pressed("upgrade_speed"):
		if MaskManager.upgrade_speed():
			_show_toast("Speed upgraded!")
		else:
			_show_toast("Need %d candy" % MaskManager.SPEED_COST)

	# Activate invisibility (spacebar)
	if Input.is_action_just_pressed("activate_invisibility"):
		_try_activate_invisibility()


func _try_activate_invisibility() -> void:
	# 1️⃣ Don't allow if not unlocked or still cooling down
	if MaskManager.invisibility_level <= 0:
		_show_toast("Invisibility unavailable")
		return
	if on_cooldown:
		_show_toast("Invisibility on cooldown")
		return
	if is_invisible:
		return  # already active, just ignore extra presses

	# 2️⃣ Pull scaling from helper
	var p := _get_invisibility_params()
	var duration : float = p.duration
	var cooldown : float = p.cooldown
	_last_cooldown_total = cooldown
	# 3️⃣ Activate invisibility visuals + collision disable
	is_invisible = true
	sprite.modulate.a = 0.3
	get_node("CollisionShape2D").set_deferred("disabled", true)

	# Optional feedback
	_show_toast("Invisibility activated!")
	print("Invisibility active for", duration, "seconds")

	# 4️⃣ Start invisibility timer
	_invis_timer.start(duration)


func _on_invisibility_timeout() -> void:
	# 1️⃣ Restore visuals and collisions
	is_invisible = false
	sprite.modulate.a = 1.0
	get_node("CollisionShape2D").set_deferred("disabled", false)

	_show_toast("Invisibility ended")
	print("Invisibility ended")

	# 2️⃣ Begin cooldown
	on_cooldown = true
	_cooldown_timer.start(_last_cooldown_total)


func _on_cooldown_timeout() -> void:
	on_cooldown = false
	_show_toast("Invisibility ready!")
	print("Cooldown finished; ability ready")


#KACHOW (Speed)
func _apply_speed() -> void:
	speed = MaskManager.current_speed(base_speed)


func _apply_mask_tint() -> void:
	var level: int = clamp(MaskManager.speed_level, 1, MaskManager.MAX_SPEED_LEVEL)
	var t: float = float(level - 1) / max(1.0, float(MaskManager.MAX_SPEED_LEVEL - 1))
	var r := 1.0 - 0.4 * t
	var g := 1.0 - 0.2 * t
	var b := 1.0
	sprite.modulate = Color(r, g, b)


func _on_speed_upgraded(new_level: int, new_speed: float) -> void:
	_apply_speed()
	_apply_mask_tint()
	_show_toast("Speed upgraded!")


func _show_toast(msg: String) -> void:
	if toast and toast.has_method("show_text"):
		toast.show_text(msg)
	else:
		print(msg)


func _get_invisibility_params() -> Dictionary:
	var level: int = max(1, MaskManager.invisibility_level)
	var duration: float = BASE_INVIS_DURATION + (level - 1) * DURATION_PER_LEVEL
	var cooldown: float = max(0.5, BASE_INVIS_COOLDOWN - (level - 1) * COOLDOWN_PER_LEVEL)
	return {
		"duration": duration,
		"cooldown": cooldown
	}
