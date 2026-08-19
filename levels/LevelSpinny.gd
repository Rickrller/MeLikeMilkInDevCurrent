extends Control

@export var level_item_scene: PackedScene = preload("res://levels/LevelItem.tscn")
@export var levels: Array[LevelData] = []

@export var slot_spacing := 180.0
@export var center_scale := 1.3
@export var side_scale := 0.85
@export var animation_time := 0.55

var current_index := 0
var item_nodes: Array[Control] = []
var is_animating := false

@onready var items_root: Control = $Levels
@onready var left_arrow: Button = $Left
@onready var right_arrow: Button = $Right
@onready var play_button: Button = $Play

func _ready() -> void:
	left_arrow.pressed.connect(_on_left_pressed)
	right_arrow.pressed.connect(_on_right_pressed)
	play_button.pressed.connect(_on_play_pressed)
	call_deferred("_build_items")

func _build_items() -> void:
	print("Building items, levels count: ", levels.size())
	for level in levels:
		var item = level_item_scene.instantiate()
		items_root.add_child(item)
		item.setup(level)
		item.pivot_offset = item.size / 2.0
		item_nodes.append(item)
	_update_display(true)

func _on_left_pressed() -> void:
	_navigate(-1)

func _on_right_pressed() -> void:
	_navigate(1)

func _on_play_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_select_current_level()

func _select_current_level() -> void:
	if levels.is_empty():
		return
	var selected: LevelData = levels[current_index]
	if selected.level_scene:
		get_tree().paused = false
		var canvas_layer = get_parent()
		while canvas_layer and not canvas_layer is CanvasLayer:
			canvas_layer = canvas_layer.get_parent()
		if canvas_layer:
			canvas_layer.queue_free()

		get_tree().change_scene_to_packed(selected.level_scene)
	else:
		push_warning("No level scene assigned for " + selected.level_name)

func _navigate(direction: int) -> void:
	if is_animating or levels.is_empty():
		return
	current_index = wrapi(current_index + direction, 0, levels.size())
	_update_display(false)

func _update_display(instant: bool) -> void:
	is_animating = true
	var center_x = items_root.size.x / 2.0
	var center_y = items_root.size.y / 2.0

	for i in item_nodes.size():
		var item = item_nodes[i]
		var offset = _wrapped_offset(i, current_index, levels.size())

		item.set_selected(offset == 0)

		var target_pos: Vector2 = Vector2(center_x + offset * slot_spacing, center_y) - item.size / 2.0
		var target_scale := Vector2.ONE * side_scale
		var target_z := 0
		var target_alpha := 0.6

		if offset == 0:
			target_scale = Vector2.ONE * center_scale
			target_z = 1
			target_alpha = 1.0
		elif absi(offset) > 1:
			target_alpha = 0.0

		item.z_index = target_z

		if instant:
			item.position = target_pos
			item.scale = target_scale
			item.modulate.a = target_alpha
		else:
			var tween = create_tween()
			tween.set_parallel(true)
			if offset == 0:
				tween.set_trans(Tween.TRANS_CUBIC)
				tween.set_ease(Tween.EASE_OUT)
				tween.tween_property(item, "position", target_pos, animation_time)
				tween.set_trans(Tween.TRANS_BACK)
				tween.set_ease(Tween.EASE_OUT)
			else:
				tween.set_trans(Tween.TRANS_CUBIC)
				tween.set_ease(Tween.EASE_OUT)
				tween.tween_property(item, "position", target_pos, animation_time)
			tween.tween_property(item, "scale", target_scale, animation_time)
			tween.tween_property(item, "modulate:a", target_alpha, animation_time)

	if not instant:
		await get_tree().create_timer(animation_time).timeout
	is_animating = false

func _wrapped_offset(index: int, center: int, total: int) -> int:
	var diff = index - center
	if diff > total / 2.0:
		diff -= total
	elif diff < -total / 2.0:
		diff += total
	return diff
