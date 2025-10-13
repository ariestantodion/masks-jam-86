#UI.gd
extends CanvasLayer

var candy: int = 0
@onready var candy_label: Label = $CandyLabel

func add_candy(amount: int = 1) -> void:
	candy += amount
	candy_label.text = "Candy: " + str(candy)

func reset() -> void:
	candy = 0
	candy_label.text = "Candy: 0"
