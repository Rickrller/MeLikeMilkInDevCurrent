extends AudioStreamPlayer

@export var air_stream: AudioStream
@export var volume_min_db: float = -40.0
@export var volume_max_db: float = -15
@export var time_to_max_volume: float = 2
@export var fade_in_speed: float = 8.0
@export var fade_out_speed: float = 2
@export var silence_threshold_db: float = -40.0 

@onready var player: CharacterBody3D = get_parent()

var air_time: float = 0.0
var was_on_floor: bool = true
var fading_out: bool = false

func _ready() -> void:
	stream = air_stream
	volume_db = silence_threshold_db

func _physics_process(delta: float) -> void:
	var on_floor := player.is_on_floor()

	if on_floor:
		if not was_on_floor:
			fading_out = true
			air_time = 0.0

		if fading_out:
			volume_db = lerp(volume_db, silence_threshold_db, delta * fade_out_speed)
			if volume_db <= silence_threshold_db + 0.5:
				stop()
				fading_out = false
	else:
		if was_on_floor:
			air_time = 0.0
			if fading_out:
				fading_out = false
			else:
				volume_db = silence_threshold_db
				play()

		air_time += delta
		var t: float = clamp(air_time / time_to_max_volume, 0.0, 1.0)
		var target_db: float = lerp(volume_min_db, volume_max_db, t)
		volume_db = lerp(volume_db, target_db, delta * fade_in_speed)

	was_on_floor = on_floor
