extends CPUParticles3D

func _ready():
	emitting = true
	await get_tree().create_timer(5).timeout
	emitting = false
	await get_tree().create_timer(5).timeout
	get_parent().queue_free()
