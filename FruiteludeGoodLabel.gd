extends Label

@export var bpm: float = 170.0
@export var trigger_beat: int = 14

@export var fade_in_speed: float = 20.0
@export var fade_out_speed: float = 1.0

var beat_timer: float = 0.0
var current_beat: int = 0

var has_triggered: bool = false
var is_fading_out: bool = false


func _ready():
	modulate.a = 0.0


func _process(delta):
	if not has_triggered:
		var beat_interval = 60.0 / bpm
		beat_timer += delta
		while beat_timer >= beat_interval:
			beat_timer -= beat_interval
			current_beat += 1
			if current_beat >= trigger_beat:
				has_triggered = true
				return
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
