extends Control

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label
@onready var panel: Panel = $Panel

var panel_style: StyleBoxFlat

func _ready() -> void:
	panel_style = panel.get_theme_stylebox("panel").duplicate()
	panel.add_theme_stylebox_override("panel", panel_style)

func setup(level_data: LevelData) -> void:
	icon.texture = level_data.icon
	label.text = level_data.level_name

func set_selected(is_selected: bool) -> void:
	if is_selected:
		panel_style.border_color = Color("bebebe")
	else:
		panel_style.border_color = Color("474747ff")
