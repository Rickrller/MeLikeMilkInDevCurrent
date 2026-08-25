extends Node3D

@export var max_yaw: float = 5.0
@export var max_pitch: float = 3.0
@export var smoothing_speed: float = 4.0

var base_rotation: Vector3
var target_rotation: Vector3
var viewport_size: Vector2

func _ready() -> void:
	base_rotation = rotation_degrees
	target_rotation = base_rotation
	viewport_size = get_viewport().get_visible_rect().size
	get_viewport().size_changed.connect(_on_viewport_resized)

func _on_viewport_resized() -> void:
	viewport_size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()

	var normalized_x: float = (mouse_pos.x / viewport_size.x) * 2.0 - 1.0
	var normalized_y: float = (mouse_pos.y / viewport_size.y) * 2.0 - 1.0

	var yaw_offset: float = -normalized_x * max_yaw
	var pitch_offset: float = -normalized_y * max_pitch

	target_rotation = base_rotation + Vector3(pitch_offset, yaw_offset, 0.0)
	rotation_degrees = rotation_degrees.lerp(target_rotation, delta * smoothing_speed)
