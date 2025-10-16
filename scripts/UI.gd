#UI.gd
extends CanvasLayer

@onready var candy_label: Label = $CandyLabel

func _ready() -> void:
	# Initialize display
	candy_label.text = "Candy: " + str(MaskManager.candy)
	
	# Connect to MaskManager signal (only once)
	if not MaskManager.candy_changed.is_connected(_on_candy_changed):
		MaskManager.candy_changed.connect(_on_candy_changed)

func _on_candy_changed(value: int) -> void:
	candy_label.text = "Candy: " + str(value)
