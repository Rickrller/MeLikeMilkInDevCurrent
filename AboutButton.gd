extends Button

@onready var target: CanvasLayer = %AboutCanvasItem  # Drag your CanvasLayer here
@export var slide_distance: float = 600.0
@export var slide_duration: float = 0.4
@export var ease_type: Tween.EaseType = Tween.EASE_OUT
@export var trans_type: Tween.TransitionType = Tween.TRANS_CUBIC

var is_open: bool = false
var shown_y: float
var hidden_y: float
var tween: Tween

func _ready() -> void:
	pressed.connect(_on_pressed)

	shown_y = target.offset.y
	hidden_y = shown_y + slide_distance

	target.offset.y = hidden_y

func _on_pressed() -> void:
	$ButtonPressed.playing = true
	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)

	var target_y: float = hidden_y if is_open else shown_y
	tween.tween_property(target, "offset:y", target_y, slide_duration)

	is_open = not is_open

func _on_mouse_entered() -> void:
	$ButtonClick.playing = true
