extends Label

@export var cycle_speed: float = 0.1
@export var saturation: float = 0.8
@export var value: float = 1.0

var hue: float = 0.0

func _process(delta: float) -> void:
	hue = fmod(hue + delta * cycle_speed, 1.0)
	modulate = Color.from_hsv(hue, saturation, value)
