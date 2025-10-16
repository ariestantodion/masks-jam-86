extends Node

var lives: int = 3
var candy: int = 0
var mask_lvl: int = 1
var speed_lvl: int = 1
var invisibility_lvl: int = 1

func _ready():
	return
	
func add_candy(amount): #'amount' only needed if some candy pickups are worth more than 1
	candy += amount     #if all candy is worth 1, remove 'amount'
	
func spend_candy(amount):
	candy -= amount
	
func upgrade_mask():
	mask_lvl += 1
	
func upgrade_speed():
	speed_lvl += 1

func upgrade_invisibility():
	invisibility_lvl += 1
	
func _process(delta):
	return
