# MaskManager.gd
extends Node

# --- Signals ---
signal candy_changed(value: int)
signal speed_upgraded(new_level: int, new_speed: float)
signal invisibility_upgraded(new_level: int)

# --- Player stats ---
var lives: int = 3
var candy: int = 0

# --- Upgrade levels ---
var speed_level: int = 1
var invisibility_level: int = 0
var mask_level: int = 1

# --- Upgrade costs & caps ---
const SPEED_COST := 5
const INVIS_COST := 8
const MAX_SPEED_LEVEL := 5
const MAX_INVIS_LEVEL := 3

# --- Level Progression ---
var house_progress: int = 0     # 0 = none cleared, 1 = House_1, 2 = House_2, 3 = House_3
var last_house_index: int = 0   # 0 = starting fresh, sets spawn to 1   # remembers which house the player exited

func mark_house_cleared(index: int) -> void:
	if index == house_progress + 1:
		house_progress = index
		print("House progress →", house_progress)

func _ready() -> void:
	print("MaskManager ready! Lives =", lives)
	
	invisibility_level = 1  # temporary, for debugging only


# --- Candy handling ---
func add_candy(amount: int = 1) -> void:
	candy += amount
	candy_changed.emit(candy)
	print("Candy added! Total candy =", candy)


func spend_candy(amount: int) -> bool:
	if candy < amount:
		return false

	candy -= amount
	candy_changed.emit(candy)
	return true


# --- Speed handling ---
func current_speed(base_speed: float = 200.0) -> float:
	# Each level adds +100 speed
	return base_speed + float(speed_level - 1) * 100.0


func upgrade_speed() -> bool:
	if speed_level >= MAX_SPEED_LEVEL:
		print("Already at max speed level.")
		return false

	if not spend_candy(SPEED_COST):
		print("Not enough candy to upgrade speed.")
		return false

	speed_level += 1
	var new_speed: float = current_speed()
	print("Speed upgraded → level:", speed_level, " new speed:", new_speed)
	speed_upgraded.emit(speed_level, new_speed)
	return true


# --- Invisibility handling ---
func upgrade_invisibility() -> bool:
	if invisibility_level >= MAX_INVIS_LEVEL:
		print("Already at max invisibility level.")
		return false

	if not spend_candy(INVIS_COST):
		print("Not enough candy to upgrade invisibility.")
		return false

	invisibility_level += 1
	print("Invisibility upgraded → level:", invisibility_level)
	invisibility_upgraded.emit(invisibility_level)
	return true
