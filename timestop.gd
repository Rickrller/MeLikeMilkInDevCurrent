extends Area3D
var affected_enemies : Array[Node3D] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 0.7
	await get_tree().create_timer(8).timeout
	monitoring = false
	for body in affected_enemies:
		if body:
			body.set_physics_process(true)
	Engine.time_scale = 1
	queue_free()





func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("fallentree"):
		affected_enemies.append(body)
		body.set_physics_process(false)
		
