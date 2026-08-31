extends Label

@export var player: Node3D
@export var tracked_node: Node3D
@export var decimals: int = 1
@export var start_distance: float = 50.0
@export var white_color: Color
@export var orange_color: Color = Color(1.0, 0.208, 0.0, 1.0)

@export var bpm: float = 170.0

@export var beat_scale: float = 1.15
@export var max_pulse_scale: float = 3.0
@export var return_speed: float = 8.0
@export var flash_speed: float = 8.0

var beat_timer: float = 0.0
var beat_count: int = 0
var text_index: int = 0

var original_scale: Vector2

var base_font_color: Color
var original_outline_color: Color
var original_shadow_color: Color

var flash_amount: float = 0.0
var current_t: float = 1.0

func _ready() -> void:
	visible = false
	label_settings = label_settings.duplicate()
	original_scale = scale
	pivot_offset = size / 2
	if label_settings:
		base_font_color = label_settings.font_color
		original_outline_color = label_settings.outline_color
		original_shadow_color = label_settings.shadow_color
	await get_tree().create_timer(5.6).timeout
	visible = true

func _process(delta: float) -> void:
	if player and tracked_node:
		var distance: float = tracked_node.global_position.distance_to(player.global_position) - 3
		text = "%.*f m" % [decimals, distance]
		current_t = clamp(distance / start_distance, 0.0, 1.0)
		base_font_color = white_color.lerp(orange_color, 1.0 - current_t)

	var beat_interval = 60.0 / bpm
	beat_timer += delta
	while beat_timer >= beat_interval:
		beat_timer -= beat_interval
		_on_beat()
	scale = scale.lerp(original_scale, delta * return_speed)
	flash_amount = move_toward(
		flash_amount,
		0.0,
		delta * flash_speed
	)
	_update_flash()


func _on_beat():
	var effective_beat_scale: float = lerp(max_pulse_scale, beat_scale, current_t)
	scale = original_scale * effective_beat_scale
	flash_amount = 1.0
	beat_count += 1


func _update_flash():
	if not label_settings:
		return

	label_settings.font_color = base_font_color.lerp(
		Color.WHITE,
		flash_amount
	)

	label_settings.outline_color = original_outline_color.lerp(
		Color.WHITE,
		flash_amount
	)

	label_settings.shadow_color = original_shadow_color.lerp(
		Color.WHITE,
		flash_amount
	)
