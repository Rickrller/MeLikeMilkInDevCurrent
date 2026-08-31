extends Area3D

@export var parent : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	queue_free()


func _on_body_entered(body: Node3D) -> void:

	if body.is_in_group("enemy") and not body.is_in_group("fallentree"):
		body.parried()
