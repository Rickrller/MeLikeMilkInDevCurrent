extends Area3D
@export var damage : float = 10

func _ready() -> void:
	$Timer.start()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#body.parried()
		if body.parrying == false:
			body.getraped(25)
			body.velocity.z -= 50 * body.camera.direction.z
			body.velocity.x -= 50 * body.camera.direction.x
			body.velocity.y += 20
		
		
	


func _on_timer_timeout() -> void:
		call_deferred("queue_free")
