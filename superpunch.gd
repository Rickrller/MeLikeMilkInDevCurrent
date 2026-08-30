extends Area3D
@export var damage : float = 50
var damagemult
@onready var FX = $FX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not damagemult:
		damagemult = 1
	await get_tree().create_timer(0.3).timeout
	FX.reparent(get_tree().current_scene,true)
	
	for child in get_children():
		print(child)
	call_deferred("queue_free")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		#body.parried(false, true, false)
		body.health -= damage# * damagemult
		
		if body.is_in_group("rigidbody"):
			body.linear_velocity.y += 3
			body.linear_velocity.z -= 50 * body.direction.z
			body.linear_velocity.x -= 50 * body.direction.x
		else:
			body.velocity.y += 15
			body.state = body.enemystate.blasted
