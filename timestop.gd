extends Area3D
var affected_enemies : Array[Node3D] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Job.playing = true
	$Timestop.playing = true
	Engine.time_scale = 0.7
	var tween = create_tween()

	#await get_tree().create_timer(3).timeout
	tween.tween_property($Job, "pitch_scale", 0.7, 2)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property($Job, "pitch_scale", 1.1, 3)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(8).timeout
	monitoring = false
	for body in affected_enemies:
		if body:
			body.set_physics_process(true)
			if body.is_in_group("rigidbody"):
				body.freeze = false
	Engine.time_scale = 1
	queue_free()





func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("fallentree"):
		affected_enemies.append(body)
		body.set_physics_process(false)
		if body.is_in_group("rigidbody"):
			body.freeze = true
