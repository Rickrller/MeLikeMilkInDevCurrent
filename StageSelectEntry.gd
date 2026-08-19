extends Area3D

var stage_select: CanvasLayer = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if stage_select or not body.is_in_group("player"):
		return
	open_stage_select()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		close_stage_select()

func open_stage_select() -> void:
	stage_select = preload("res://levels/LevelSelectionUI.tscn").instantiate()
	get_tree().root.add_child(stage_select)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var screen_height = get_viewport().get_visible_rect().size.y
	stage_select.offset.y = screen_height
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(stage_select, "offset:y", 0.0, 0.8)

func close_stage_select() -> void:
	if not stage_select:
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var screen_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(stage_select, "offset:y", screen_height, 0.8)
	tween.finished.connect(func():
		stage_select.queue_free()
		stage_select = null
)
