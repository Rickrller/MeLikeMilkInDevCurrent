extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var src = $"..".position
	print(src)
	print($"../CollisionShape3D".position)
	print(position)
	for child in get_children():
		child.emitting = true
		remove_child(child)
		get_tree().root.add_child(child)
	await get_tree().create_timer(10).timeout
	queue_free()
