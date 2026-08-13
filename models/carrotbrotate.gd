extends Node3D
@onready var player = get_tree().get_first_node_in_group("player")
@export var target_pos : Vector3
@export var target_transform : Transform3D
@export var target_quaternion : Vector3




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 2 == 0:
		lookatplayer()

func lookatplayer():
	
	
	target_pos = player.global_position
	target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	target_quaternion = target_transform.basis.get_euler()
	rotation = lerp(rotation, target_quaternion, 1)
	$"../EnemyHitbox".rotation = lerp(rotation, target_quaternion, 1)
