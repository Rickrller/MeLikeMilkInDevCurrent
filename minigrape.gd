extends RigidBody3D

@onready var parent = get_parent()
@onready var AOE = $AOE
@onready var VFX = load("res://GrapeVFX.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = global_position.direction_to(parent.global_position)
	linear_velocity.y += 10
	linear_velocity.x = -dir.x * 3.5
	linear_velocity.z = -dir.z * 3.5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	await get_tree().create_timer(1.5).timeout
	var VFXInstance = VFX.instantiate()
	VFXInstance.global_transform = global_transform
	get_tree().root.add_child(VFXInstance)
	AOE.monitoring = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()


func _on_aoe_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.health -= 15
