extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity.y += 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	await get_tree().create_timer(1).timeout
	queue_free()
