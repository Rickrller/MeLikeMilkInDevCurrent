extends Label

@export var float_distance := 400.0
@export var rise_duration := 0.6

@export var bob_amplitude := 6.0
@export var bob_duration := 1.2

@export var rise_rotation_deg := 15.0
@export var bob_rotation_deg := 3.0
@export var bob_rotation_duration := 1.6

@export var burst_scale := 1.3
@export var burst_out_duration := 0.08
@export var burst_back_duration := 0.25

var base_center: Vector2
var anchor_center: Vector2
var anchor_rotation: float = 0.0
var time_elapsed := 0.0

var burst_tween: Tween
var is_ready := false

func _ready() -> void:
	resized.connect(_on_resized)
	await get_tree().process_frame
	base_center = position + size / 2.0
	pivot_offset = size / 2.0
	anchor_center = base_center + Vector2(0, float_distance)
	modulate.a = 0.0
	anchor_rotation = rise_rotation_deg
	rotation_degrees = anchor_rotation
	position = anchor_center - size / 2.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "anchor_center", base_center, rise_duration)
	tween.tween_property(self, "modulate:a", 1.0, rise_duration * 0.6)
	tween.tween_property(self, "anchor_rotation", 0.0, rise_duration)
	is_ready = true

func _on_resized() -> void:
	pivot_offset = size / 2.0
	base_center = position + size / 2.0
	if is_ready:
		_burst()

func _burst() -> void:
	if burst_tween:
		burst_tween.kill()
	scale = Vector2.ONE
	burst_tween = create_tween()
	burst_tween.set_trans(Tween.TRANS_BACK)
	burst_tween.set_ease(Tween.EASE_OUT)
	burst_tween.tween_property(self, "scale", Vector2.ONE * burst_scale, burst_out_duration)
	burst_tween.tween_property(self, "scale", Vector2.ONE, burst_back_duration)

func _process(delta: float) -> void:
	time_elapsed += delta
	var bob_y := sin(time_elapsed * TAU / bob_duration) * bob_amplitude
	var bob_rot := sin(time_elapsed * TAU / bob_rotation_duration) * bob_rotation_deg
	position = (anchor_center - size / 2.0) + Vector2(0, bob_y)
	rotation_degrees = anchor_rotation + bob_rot
