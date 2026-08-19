extends Node3D

@export var rot_speed: float = 20.0

var neck: Node3D
var arm_scale: Vector3

func _ready():
	var gt = global_transform
	top_level = true
	global_transform = gt
	arm_scale = gt.basis.get_scale()
	neck = get_parent()

func _physics_process(delta):
	global_position = neck.global_position
	position.y -= 0.5
	var rot_t = 1.0 - exp(-rot_speed * delta)
	var current_rot = global_transform.basis.get_rotation_quaternion()
	var target_rot = neck.global_transform.basis.get_rotation_quaternion()
	var new_rot = current_rot.slerp(target_rot, rot_t)

	global_transform.basis = Basis(new_rot).scaled(arm_scale)
