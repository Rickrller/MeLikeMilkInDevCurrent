extends CanvasLayer

@export var main_menu_scene_path: String = "res://GameMenu.tscn"

@onready var resume_button: Button = $CenterContainer/Control/Resume
@onready var exit_button: Button = $CenterContainer/Control/Exit
@onready var menu_button: Button = $CenterContainer/Control/Menu

var _slide_distance: float = 60.0
var _anim_duration: float = 0.25
var _previous_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	menu_button.pressed.connect(_on_menu_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func toggle_pause() -> void:
	if get_tree().paused:
		resume()
	else:
		pause()


func pause() -> void:
	get_tree().paused = true
	visible = true

	_previous_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	offset.y = _slide_distance

	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "offset:y", 0.0, _anim_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func resume() -> void:
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "offset:y", _slide_distance, _anim_duration)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	tween.chain().tween_callback(func():
		get_tree().paused = false
		visible = false
		Input.mouse_mode = _previous_mouse_mode
	)


func _on_resume_pressed() -> void:
	resume()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_menu_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if main_menu_scene_path != "":
		get_tree().change_scene_to_file(main_menu_scene_path)
	else:
		push_warning("main_menu_scene_path is empty — set it in the Inspector or script.")
