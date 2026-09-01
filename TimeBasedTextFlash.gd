extends Label
@export var trigger_time: float = 4.94
@export var fade_in_speed: float = 20.0
@export var fade_out_speed: float = 1.0
var elapsed_time: float = 0.0
var has_triggered: bool = false
var is_fading_out: bool = false
func _ready():
	modulate.a = 0.0
func _process(delta):
	if not has_triggered:
		elapsed_time += delta
		if elapsed_time >= trigger_time:
			has_triggered = true
	elif not is_fading_out:
		modulate.a = move_toward(
			modulate.a,
			1.0,
			delta * fade_in_speed
		)
		if modulate.a >= 1.0:
			is_fading_out = true
	else:
		modulate.a = move_toward(
			modulate.a,
			0.0,
			delta * fade_out_speed
		)
		if modulate.a <= 0.0:
			set_process(false)
