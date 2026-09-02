extends AudioStreamPlayer

func _ready() -> void:
	playing = true
	await get_tree().create_timer(5).timeout
	get_parent().queue_free()
	queue_free()
