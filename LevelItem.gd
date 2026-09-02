extends Control

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label
@onready var panel: Panel = $Panel

var panel_style: StyleBoxFlat
var label_settings: LabelSettings
var level_data: LevelData

const SELECTED_COLOR := Color("bebebe")
const UNSELECTED_COLOR := Color("474747ff")
const HIGHLIGHT_COLOR := Color("ff4700ff")

var is_selected := false
var is_highlighted := false

func _ready() -> void:
	panel_style = panel.get_theme_stylebox("panel").duplicate()
	panel.add_theme_stylebox_override("panel", panel_style)

	label_settings = label.label_settings.duplicate()
	label.label_settings = label_settings

func setup(data: LevelData) -> void:
	level_data = data
	icon.texture = data.icon
	label.text = data.level_name

func set_selected(selected: bool) -> void:
	is_selected = selected
	_update_border()

func set_highlighted(highlighted: bool) -> void:
	is_highlighted = highlighted
	_update_border()

func _update_border() -> void:
	var color := HIGHLIGHT_COLOR if is_highlighted else (SELECTED_COLOR if is_selected else UNSELECTED_COLOR)
	panel_style.border_color = color
	label_settings.outline_color = color
