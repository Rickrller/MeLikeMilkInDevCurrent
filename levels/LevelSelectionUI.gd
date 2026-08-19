extends Area3D

var stage_select: Control = null

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

	# Start off-screen (below the viewport)
	var screen_height = get_viewport().get_visible_rect().size.y
	var target_pos = stage_select.position
	stage_select.position.y = target_pos.y + screen_height

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(stage_select, "position:y", target_pos.y, 0.4)

func close_stage_select() -> void:
	if not stage_select:
		return
	var screen_height = get_viewport().get_visible_rect().size.y
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(stage_select, "position:y", stage_select.position.y + screen_height, 0.3)
	tween.finished.connect(func():
		stage_select.queue_free()
		stage_select = null
)
