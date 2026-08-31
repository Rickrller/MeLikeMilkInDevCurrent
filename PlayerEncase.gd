extends Node3D

func _ready() -> void:
	await get_tree().create_timer(5.6).timeout
	queue_free()
