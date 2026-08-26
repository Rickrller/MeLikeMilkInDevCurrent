extends Area3D
var time = 8
@export var target : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape3D/SmokeLong.emitting = true
	await get_tree().create_timer(time).timeout
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	while body.is_in_group(target) and is_instance_valid(body):
		await get_tree().create_timer(1).timeout
		if body:
			body.health -= 3
		else:
			break
