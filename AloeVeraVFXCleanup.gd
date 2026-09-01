extends CPUParticles3D

func _ready() -> void:
	emitting = true
	await get_tree().create_timer(10).timeout
	get_parent().queue_free()
