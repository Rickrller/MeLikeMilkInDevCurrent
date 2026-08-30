extends Node2D

const VU_COUNT = 64
const HALF_COUNT = VU_COUNT / 2 
const FREQ_MIN = 20.0
const FREQ_MAX = 11050.0
const MIN_DB = 60
const ATTACK_SPEED = 95.0 
const DECAY_SPEED = 14.0 

@export var jitter_strength: float = 0.5

@export var punch_scale_amount: float = 0.1
@export var punch_decay_tau: float = 0.10 
@export var flash_amount: float = 1
@export var flash_decay_tau: float = 0.09 

@export var bpm: float = 170.0

@export var pulse_speed: float = 120.0 
@export var pulse_width: float = 3.0 
@export var pulse_decay_tau: float = 0.30 
@export var pulse_boost: float = 0.4

@export var bar_color: Color = Color(0.913, 0.29, 0.0, 1.0)

@export var center_shape_min: float = 0.35
@export var center_shape_max: float = 2

var spectrum
var heights = []
var _elapsed: float = 0.0
var _beat_timer: float = 0.0
var _pulses = []
var _punch_scale: float = 0.0
var _flash_intensity: float = 0.0

func _ready():
	var bus_index = AudioServer.get_bus_index("Master")
	spectrum = AudioServer.get_bus_effect_instance(bus_index, 0)
	heights.resize(VU_COUNT)
	for i in range(VU_COUNT):
		heights[i] = 0.0

func _process(delta):
	_elapsed += delta
	for i in range(VU_COUNT):
		var half_index: int
		if i < HALF_COUNT:
			half_index = HALF_COUNT - 1 - i
		else:
			half_index = i - HALF_COUNT
		var t0 = float(half_index) / HALF_COUNT
		var t1 = float(half_index + 1) / HALF_COUNT
		var lo_hz = FREQ_MIN * pow(FREQ_MAX / FREQ_MIN, t0)
		var hi_hz = FREQ_MIN * pow(FREQ_MAX / FREQ_MIN, t1)
		var magnitude = spectrum.get_magnitude_for_frequency_range(lo_hz, hi_hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var speed = ATTACK_SPEED if energy > heights[i] else DECAY_SPEED
		heights[i] = lerpf(heights[i], float(energy), float(delta * speed))
	_advance_beat_clock(delta)
	_prune_pulses()
	_punch_scale *= exp(-delta / punch_decay_tau)
	_flash_intensity *= exp(-delta / flash_decay_tau)
	var current_scale: float = 1.0 + _punch_scale
	var pivot: Vector2 = get_viewport_rect().size * 0.5
	scale = Vector2.ONE * current_scale
	position = pivot - pivot * current_scale

	queue_redraw()

func _advance_beat_clock(delta):
	var beat_interval: float = 60.0 / max(1.0, bpm)
	_beat_timer += delta
	if _beat_timer >= beat_interval:
		_beat_timer -= beat_interval
		_trigger_beat()

func _trigger_beat():
	_pulses.append({"start": _elapsed, "origin": (VU_COUNT - 1) / 2.0})
	_punch_scale += punch_scale_amount
	_flash_intensity += flash_amount

func _prune_pulses():
	var alive = []
	for p in _pulses:
		var age = _elapsed - p["start"]
		var amplitude = pulse_boost * exp(-age / pulse_decay_tau)
		var traveled = age * pulse_speed
		if amplitude > 0.02 and traveled < VU_COUNT + pulse_width * 2.0:
			alive.append(p)
	_pulses = alive

func _pulse_boost_for_bar(i: int) -> float:
	var boost: float = 0.0
	for p in _pulses:
		var age = _elapsed - p["start"]
		var amplitude = pulse_boost * exp(-age / pulse_decay_tau)
		var traveled = age * pulse_speed
		var distance = abs(i - p["origin"])
		var ring_factor = exp(-pow(distance - traveled, 2.0) / (2.0 * pulse_width * pulse_width))
		boost += amplitude * ring_factor
	return boost

func _draw():
	var full_width = get_viewport_rect().size.x
	var full_height = get_viewport_rect().size.y
	var width = full_width
	var start_x = 0
	var center_index = (VU_COUNT - 1) / 2.0
	for i in range(VU_COUNT):
		var boost = _pulse_boost_for_bar(i)
		var dist_from_center = abs(i - center_index) / center_index
		var shape_mult = lerp(center_shape_min, center_shape_max, dist_from_center)
		var display_height = clamp((heights[i] + boost) * shape_mult, 0.0, 1.4)
		var jitter = (randf() * 2.0 - 1.0) * jitter_strength * display_height
		display_height = clamp(display_height + jitter, 0.0, 1.5)
		var bar_height = display_height * full_height
		var slot_width = width / VU_COUNT
		var base_width = slot_width * 1.6
		var center_x = start_x + i * slot_width + slot_width / 2
		var steps = 5
		for j in range(steps):
			var t = float(j) / steps
			var segment_height = bar_height / steps
			var y = full_height - (j + 1) * segment_height
			var current_width = base_width * (1.0 - t)
			var x = center_x - current_width / 2
			var falloff_alpha = pow(1.0 - t, 2.0)
			var glow_alpha = clamp(0.5 + boost, 0.5, 1.0)
			var alpha = falloff_alpha * glow_alpha
			var flashed_color = bar_color.lerp(Color(1, 1, 1, 1), _flash_intensity)
			draw_rect(Rect2(
				x,
				y,
				current_width,
				segment_height + 1
			), Color(flashed_color.r, flashed_color.g, flashed_color.b, flashed_color.a * alpha))
