extends AudioStreamPlayer

@export var pitch_min: float = 0.9
@export var pitch_max: float = 1.1

func _ready() -> void:
	pitch_scale = randf_range(pitch_min, pitch_max)
	play()
