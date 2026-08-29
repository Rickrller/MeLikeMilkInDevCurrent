extends Label

@onready var player = get_parent().get_parent()
@onready var bar: ProgressBar = $Bar

var last_health: float
var max_health = 100
var _pivot_set: bool = false
var _tween: Tween
var _pulse_tween: Tween
var _is_pulsing: bool = false
var _fill_style: StyleBoxFlat

var pop_scale_min: float = 1.05
var pop_scale_max: float = 1.4
var pop_duration: float = 0.05
var ease_duration: float = 0.35
var color_duration: float = 0.25
var flash_duration: float = 0.08
var critical_threshold: float = 0.25
var full_health_color: Color = Color(0.2, 0.9, 0.3)
var empty_health_color: Color = Color(0.95, 0.2, 0.2)
var flash_color: Color = Color(1, 1, 1)
var fill_corner_radius: int = 6

func _ready():
	modulate = Color(1, 1, 1, 1)
	bar.modulate = Color(1, 1, 1, 1)
	bar.add_theme_color_override("font_color", Color(1, 1, 1, 1))

	_fill_style = StyleBoxFlat.new()
	_fill_style.bg_color = full_health_color
	_fill_style.corner_radius_top_left = fill_corner_radius
	_fill_style.corner_radius_top_right = fill_corner_radius
	_fill_style.corner_radius_bottom_left = fill_corner_radius
	_fill_style.corner_radius_bottom_right = fill_corner_radius
	bar.add_theme_stylebox_override("fill", _fill_style)

	last_health = player.health
	bar.min_value = 0
	bar.max_value = max_health
	update_health(player.health, max_health, false)

func _process(_delta):
	if player.health != last_health:
		update_health(player.health, max_health)
	last_health = player.health

func update_health(new_health: float, max_health: float, animate: bool = true) -> void:
	if not _pivot_set:
		bar.pivot_offset = bar.size / 2.0
		_pivot_set = true

	var current_health: float = clamp(new_health, 0.0, max_health)
	var percent: float = current_health / max_health
	var damage_taken: float = max(0.0, last_health - current_health)
	var damage_percent: float = clamp(damage_taken / max_health, 0.0, 1.0)

	text = "HP: %d" % int(current_health)
	bar.value = current_health

	var target_color: Color = full_health_color.lerp(empty_health_color, 1.0 - percent)

	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_parallel(true)

	if animate and damage_taken > 0.0:
		_tween.tween_property(_fill_style, "bg_color", flash_color, flash_duration)
		_tween.chain().tween_property(_fill_style, "bg_color", target_color, color_duration)
	else:
		_tween.tween_property(_fill_style, "bg_color", target_color, color_duration)

	if animate:
		var pop_scale: float = lerp(pop_scale_min, pop_scale_max, damage_percent)
		_tween.tween_property(bar, "scale", Vector2(pop_scale, pop_scale), pop_duration) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_tween.chain().tween_property(bar, "scale", Vector2.ONE, ease_duration) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		bar.scale = Vector2.ONE

	_update_pulse(percent)

func _update_pulse(percent: float) -> void:
	var should_pulse: bool = percent > 0.0 and percent <= critical_threshold

	if should_pulse and not _is_pulsing:
		_is_pulsing = true
		_pulse_tween = create_tween()
		_pulse_tween.set_loops()
		_pulse_tween.tween_property(_fill_style, "bg_color:a", 0.4, 0.4) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		_pulse_tween.tween_property(_fill_style, "bg_color:a", 1.0, 0.4) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	elif not should_pulse and _is_pulsing:
		_is_pulsing = false
		if _pulse_tween:
			_pulse_tween.kill()
		_fill_style.bg_color.a = 1.0
