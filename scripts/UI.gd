extends CanvasLayer

@onready var candy_label: Label = $CandyLabel
@onready var lives_label: Label = $LivesLabel

func _ready() -> void:
	# Initialize labels
	candy_label.text = "Candy: " + str(MaskManager.candy)
	lives_label.text = "Lives: " + str(GameManager.lives)

	# Connect signals (only once)
	if not MaskManager.candy_changed.is_connected(_on_candy_changed):
		MaskManager.candy_changed.connect(_on_candy_changed)

	if not GameManager.lives_changed.is_connected(_on_lives_changed):
		GameManager.lives_changed.connect(_on_lives_changed)

func _on_candy_changed(value: int) -> void:
	candy_label.text = "Candy: " + str(value)

func _on_lives_changed(value: int) -> void:
	lives_label.text = "Lives: " + str(value)
