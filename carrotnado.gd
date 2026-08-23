extends Area3D

@export var members : Array[Node3D] = []
@onready var ray = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	ray.force_raycast_update()
	if not ray.is_colliding():
		queue_free()
		return
	var pos = ray.get_collision_point()
	global_position = pos
	ray.queue_free()
	await get_tree().create_timer(5).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	for body in members:
		body.velocity = 8 * body.global_position.direction_to(global_position)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		if body.is_in_group("rigidbody"):
			return
		members.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body in members:
		members.erase(body)
