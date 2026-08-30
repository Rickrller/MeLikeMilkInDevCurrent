extends Label

@export var bpm: float = 170.0

@export var beat_scale: float = 1.15
@export var return_speed: float = 8.0
@export var flash_speed: float = 8.0

@export var texts: Array[String] = [
	"PUNCH FALLEN TREES TO BREAK THEM",
	"YOU HAVE 4 MINUTES TO GET TO THE END",
	""
]

var beat_timer: float = 0.0
var beat_count: int = 0
var text_index: int = 0

var original_scale: Vector2

var original_font_color: Color
var original_outline_color: Color
var original_shadow_color: Color

var flash_amount: float = 0.0


func _ready():
	original_scale = scale
	pivot_offset = size / 2

	if label_settings:
		original_font_color = label_settings.font_color
		original_outline_color = label_settings.outline_color
		original_shadow_color = label_settings.shadow_color

	if texts.size() > 0:
		text = texts[0]


func _process(delta):
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
	scale = original_scale * beat_scale
	flash_amount = 1.0

	beat_count += 1

	if beat_count >= 8:
		beat_count = 0
		_change_text()


func _update_flash():
	if not label_settings:
		return

	label_settings.font_color = original_font_color.lerp(
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


func _change_text():
	if text_index >= texts.size() - 1:
		return

	text_index += 1
	text = texts[text_index]

	await get_tree().process_frame
	pivot_offset = size / 2
