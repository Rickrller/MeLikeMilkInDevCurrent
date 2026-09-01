extends Label3D

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")

@export var turn_speed: float = 5.0

func _process(delta: float) -> void:
	if player:
		var target_transform := global_transform.looking_at(player.global_position, Vector3.UP)
		target_transform = target_transform.rotated_local(Vector3.UP, PI)
		global_transform.basis = global_transform.basis.slerp(target_transform.basis, delta * turn_speed)
