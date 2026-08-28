extends Area3D

@export var heal_amount: float = 3.0
@export var tick_interval: float = 1.0

var bodies_in_area: Array[Node3D] = []
var tick_timer: float = 0.0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		bodies_in_area.append(body)

func _on_body_exited(body: Node3D) -> void:
	bodies_in_area.erase(body)

func _process(delta: float) -> void:
	tick_timer += delta
	if tick_timer >= tick_interval:
		tick_timer = 0.0
		for body in bodies_in_area:
			if is_instance_valid(body):
				body.health += heal_amount
