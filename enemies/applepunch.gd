extends Area3D
@export var damage : float = 10

func _ready() -> void:
	$Timer.start()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#body.parried()
		body.getraped(25)
		body.velocity -= 100 * body.camera.direction
		
		
	


func _on_timer_timeout() -> void:
		call_deferred("queue_free")
