extends CharacterBody2D

signal player_hit

@export var speed: float = 200
@export var min_time: float = 1.0   # Minimum time before flipping
@export var max_time: float = 3.0   # Maximum time before flipping

var direction: int = 1  # 1 = right, -1 = left

@onready var timer: Timer = $Timer 

func _ready() -> void:
	_set_random_timer()
	timer.start()

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	move_and_slide()

func _on_Timer_timeout() -> void:
	direction *= -1
	_set_random_timer()
	timer.start()

func _set_random_timer() -> void:
	timer.wait_time = randf_range(min_time, max_time)
	
