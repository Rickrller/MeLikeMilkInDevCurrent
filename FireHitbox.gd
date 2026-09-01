extends Area3D

@export_file("*.tscn") var target_scene: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		call_deferred("change_scene_to_file_deferred")
	if body.is_in_group("enemy"):
		body.health = 0

func change_scene_to_file_deferred() -> void:
	get_tree().change_scene_to_file(target_scene)
