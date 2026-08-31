extends Area3D
var damage = 20
@export var parent : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	queue_free()


func _on_body_entered(body: Node3D) -> void:

	if body.is_in_group("enemy") and not body.is_in_group("fallentree"):
		if body.is_in_group("rigidbody"):
			body.linear_velocity.y += 3
			body.linear_velocity.z -= 50 * body.direction.z
			body.linear_velocity.x -= 50 * body.direction.x
		else:
			body.velocity.y += 15
			body.state = body.enemystate.blasted
