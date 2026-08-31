extends Node3D

@export var distance: float = 1500.0
@export var duration: float = 240.0

var speed: float
var elapsed: float = 0.0
var moving: bool = true

func _ready() -> void:
	await get_tree().create_timer(5.6).timeout
	speed = distance / duration 

func _process(delta: float) -> void:
	if moving:
		elapsed += delta
		if elapsed >= duration:
			delta -= (elapsed - duration)
			moving = false
		position.x -= speed * delta
