extends multistate
@onready var player = get_tree().get_first_node_in_group("player")

func Physics_Update(delta: float):
	if player:
		player.velocity.x = lerp(player.velocity.x, player.direction.x * player.speed * player.speedmult, player.acceleration * delta)
		player.velocity.z = lerp(player.velocity.z, player.direction.z * player.speed * player.speedmult,player.acceleration * delta)
		if not player.direction:
			eventbus.switch_activity.emit(self, "disable")
