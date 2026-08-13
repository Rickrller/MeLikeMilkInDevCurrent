extends CharacterBody3D
@export var touchedfloor : bool = false
@export var health : float
@export var givenfruit : String
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
	if is_on_floor():
		velocity.y += 20
		touchedfloor = true
		
	if not is_on_floor() and touchedfloor == false:
		velocity.y -= gravity * delta
	else:
		velocity.y = lerp(velocity.y, 0.0, 0.05)
	move_and_slide()


func _on_buffarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and body != self:
		body.speed *= 2
		if not body.is_in_group("rigidbody"):
			body.attackcooldown.wait_time *= 0.75


func _on_buffarea_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy") and body != self:
		body.speed /= 2
		if not body.is_in_group("rigidbody"):
			body.attackcooldown.wait_time /= 0.75


func parried():
	eventbus.grantitem.emit(givenfruit)
	queue_free()
