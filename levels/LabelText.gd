extends Label

@export var max_font_size: int = 100
@export var min_font_size: int = 10

func _ready() -> void:
	clip_text = true 
	item_rect_changed.connect(update_font_size)
	update_font_size()

func _set(property: StringName, value: Variant) -> bool:
	if property == &"text":
		text = value
		update_font_size()
		return true
	return false

func update_font_size() -> void:
	if text.is_empty():
		return
		
	var font = get_theme_font("font")
	var current_size = max_font_size
	while current_size > min_font_size:
		var text_size = font.get_string_size(text, horizontal_alignment, -1, current_size)
		if text_size.x <= size.x:
			break
		current_size -= 1
	add_theme_font_size_override("font_size", current_size)
