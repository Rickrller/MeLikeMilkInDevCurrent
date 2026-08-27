extends Node3D

var src
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child in get_children():
		child.emitting = true
	await get_tree().create_timer(10).timeout
	queue_free()
