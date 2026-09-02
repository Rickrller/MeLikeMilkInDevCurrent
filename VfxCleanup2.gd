extends CPUParticles3D

func _ready():
	one_shot = true
	emitting = true
	var total_time = 5
	await get_tree().create_timer(total_time).timeout
	get_parent().get_parent().queue_free()
