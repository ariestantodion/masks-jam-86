extends CharacterBody2D

signal player_hit

@export var speed: float = 200
@export var min_time: float = 1.0
@export var max_time: float = 3.0
@export var direction := 1

@onready var timer: Timer = $Timer

func _ready() -> void:
	_set_random_timer()
	timer.start()

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	velocity.y = direction * speed
	move_and_slide()

func _on_Timer_timeout() -> void:
	direction *= -1
	_set_random_timer()
	timer.start()

func _set_random_timer() -> void:
	timer.wait_time = randf_range(min_time, max_time)

# THIS NAME MUST MATCH THE NODE NAME ("Hitbox")
func _on_Hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.on_player_hit()  # directly call the singleton’s function
