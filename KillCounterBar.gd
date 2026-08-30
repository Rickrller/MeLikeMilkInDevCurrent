extends ProgressBar

var flash_tween: Tween
var base_fill_color: Color

func _ready() -> void:
	KillCounter.kill_count_changed.connect(_on_kill_count_changed)
	max_value = KillCounter.required_kills
	value = KillCounter.current_kills
	
	# Duplicate the fill StyleBox so we can safely animate it without affecting the shared theme resource
	var fill_style: StyleBoxFlat = get_theme_stylebox("fill").duplicate()
	base_fill_color = fill_style.bg_color  # should be your red
	add_theme_stylebox_override("fill", fill_style)

func _on_kill_count_changed(current: int, required: int) -> void:
	max_value = required
	var tween := create_tween()
	tween.tween_property(self, "value", current, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if current >= required:
		await tween.finished
		_start_flashing()
	else:
		_stop_flashing()

func _start_flashing() -> void:
	_stop_flashing()
	var fill_style: StyleBoxFlat = get_theme_stylebox("fill")
	
	flash_tween = create_tween()
	flash_tween.set_loops()
	flash_tween.tween_property(fill_style, "bg_color", Color.WHITE, 0.4).set_trans(Tween.TRANS_SINE)
	flash_tween.tween_property(fill_style, "bg_color", base_fill_color, 0.4).set_trans(Tween.TRANS_SINE)

func _stop_flashing() -> void:
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	var fill_style: StyleBoxFlat = get_theme_stylebox("fill")
	if fill_style:
		fill_style.bg_color = base_fill_color
