extends Node3D

@export var follow_speed : float = 0
@onready var player: Node3D = null

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	if not player:
		return

	var target_x := player.global_position.x

	if follow_speed <= 0.0:
		global_position.x = target_x
	else:
		global_position.x = lerp(global_position.x, target_x, follow_speed * delta)
