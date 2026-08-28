extends Camera3D

var direction

@export var base_fov: float = 75.0
@export var max_fov: float = 160.0
@export var fov_lerp_speed: float = 8.0
@export var speed_sensitivity: float = 30.0

@onready var player: CharacterBody3D = get_parent().get_parent().get_parent()



func _process(delta: float) -> void:
	var vel := player.velocity
	var y_component: float = vel.y if vel.y < 0.0 else 0.0
	var effective_velocity := Vector3(vel.x, y_component, vel.z)
	var current_speed: float = effective_velocity.length()
	var speed_ratio: float = current_speed / (current_speed + speed_sensitivity)
	var target_fov: float = lerp(base_fov, max_fov, speed_ratio)
	fov = lerp(fov, target_fov, fov_lerp_speed * delta)

func _physics_process(_delta: float) -> void:
	direction = -global_transform.basis.z.normalized()
