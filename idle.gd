extends multistate
@onready var player = get_tree().get_first_node_in_group("player")
func Physics_Update(delta: float):
	if player:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.friction * delta)
		player.velocity.z = lerp(player.velocity.z, 0.0, player.friction * delta)
		if player.direction:
			eventbus.switch_activity.emit(self, "disable")
	else:
		#print("player not found")
		pass

#func Enable():
	#idleanim = false
	#$"../../Neck/arm/AnimationPlayer".play("idle")
	#$"../../Neck/arm2/AnimationPlayer".play("idle")
#
#func Disable():
	#idleanim = false
	#
