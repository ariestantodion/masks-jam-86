# Player.gd
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

# Base speed before any upgrades
@export var base_speed := 200.0
var speed := 200.0

# Optional reference to the toast (popup) UI
var toast: Node = null
var invisibility_cooldown: bool = false


func _ready() -> void:
	print("MaskManager loaded:", MaskManager)
	print("Current candy:", MaskManager.candy)

	# Find the Toast node in the scene tree (group name = "toast")
	toast = get_tree().get_first_node_in_group("toast")

	# Apply initial speed & color
	_apply_speed()
	_apply_mask_tint()

	# Connect to MaskManager's signal so upgrades update this player immediately
	if not MaskManager.speed_upgraded.is_connected(_on_speed_upgraded):
		MaskManager.speed_upgraded.connect(_on_speed_upgraded)


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
			
	if Input.is_action_just_pressed("activate_invisibility"):
		if MaskManager.invisibility_level >= 1 and invisibility_cooldown == false:
			get_node("Sprite2D").modulate.a = 0.3
			get_node("CollisionShape2D").set_deferred("disabled", true)
			await get_tree().create_timer(5.0).timeout #Timer for invisibility duration, update to a variable that increases with invisibilty lvl
			invisibility_cooldown = true
			get_node("Sprite2D").modulate.a = 1.0
			get_node("CollisionShape2D").set_deferred("disabled", false)
			await get_tree().create_timer(10.0).timeout #Invisibility cooldown timer
			invisibility_cooldown = false
		elif MaskManager.invisibility_level >= 1 and invisibility_cooldown == true:
			_show_toast("Invisibility on cooldown")
		else:
			_show_toast("Invisibility unavailable")


func _apply_speed() -> void:
	# Pull the current speed from MaskManager
	speed = MaskManager.current_speed(base_speed)


func _apply_mask_tint() -> void:
	var level: int = clamp(MaskManager.speed_level, 1, MaskManager.MAX_SPEED_LEVEL)
	var t: float = float(level - 1) / max(1.0, float(MaskManager.MAX_SPEED_LEVEL - 1))
	
	# Dramatic color change — white → bright cyan as speed increases
	var r := 1.0 - 0.4 * t
	var g := 1.0 - 0.2 * t
	var b := 1.0
	sprite.modulate = Color(r, g, b)


func _on_speed_upgraded(new_level: int, new_speed: float) -> void:
	# When MaskManager upgrades, update locally
	_apply_speed()
	_apply_mask_tint()
	_show_toast("Speed upgraded!")


func _show_toast(msg: String) -> void:
	# If the Toast scene exists in the current scene tree, show text
	if toast and toast.has_method("show_text"):
		toast.show_text(msg)
	else:
		# fallback for safety
		print(msg)
