#MaskManager.gd
extends Node

# --- Signals ---
signal candy_changed(value: int)
signal speed_upgraded(new_level: int, new_speed: float)
signal invisibility_upgraded(new_level: int)

# --- Player stats ---
var lives: int = 3
var candy: int = 0

# Upgrade levels
var speed_level: int = 1
var invisibility_level: int = 0
var mask_level: int = 1

# --- Constants for costs and scaling ---
const SPEED_COST := 5
const INVIS_COST := 8
const MAX_SPEED_LEVEL := 5
const MAX_INVIS_LEVEL := 3


func _ready() -> void:
	print("MaskManager ready! Lives =", lives)


# --- Core helper functions ---
func add_candy(amount: int = 1) -> void:
	candy += amount
	candy_changed.emit(candy)
	print("Candy added! Total candy =", candy)


func spend_candy(amount: int) -> bool:
	if candy >= amount:
		candy -= amount
		candy_changed.emit(candy)
		return true
	else:
		return false


# --- Speed handling ---
func current_speed(base_speed: float = 200.0) -> float:
	return base_speed + float(speed_level - 1) * 100.0


func upgrade_speed() -> bool:
	if speed_level >= MAX_SPEED_LEVEL:
		print("Already at max speed level.")
		return false
	if spend_candy(SPEED_COST):
		speed_level += 1
		var new_speed := current_speed()
		print("Speed upgraded to level", speed_level, "→ new speed =", new_speed)
		speed_upgraded.emit(speed_level, new_speed)
		return true
	else:
		print("Not enough candy to upgrade speed.")
		return false


# --- Invisibility handling (for later) ---
func upgrade_invisibility() -> bool:
	if invisibility_level >= MAX_INVIS_LEVEL:
		print("Already at max invisibility level.")
		return false
	if spend_candy(INVIS_COST):
		invisibility_level += 1
		print("Invisibility upgraded to level", invisibility_level)
		invisibility_upgraded.emit(invisibility_level)
		return true
	else:
		print("Not enough candy to upgrade invisibility.")
		return false
