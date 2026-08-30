extends Sprite2D

const BPM = 170.0
const MIN_SCALE = 0.4
const MAX_SCALE = 1

var beat_time = 0.0
var beat_interval = 60.0 / BPM
var is_active = true

func _process(delta):
	if not is_active:
		return
	beat_time += delta
	if beat_time >= beat_interval:
		beat_time -= beat_interval
		scale = Vector2(MIN_SCALE, MIN_SCALE)
		modulate.a = 1.0
	var t = beat_time / beat_interval
	var curve = pow(t, 1.2)
	var scale_amount = lerpf(MIN_SCALE, MAX_SCALE, curve)
	scale = Vector2(scale_amount, scale_amount) * 8
	modulate.a = 1.0 - curve

func start_bop():
	is_active = true
	beat_time = 0.0
	scale = Vector2(MIN_SCALE, MIN_SCALE)
	modulate.a = 1.0

func stop_bop():
	is_active = false
	scale = Vector2(1, 1)
	modulate.a = 1.0
