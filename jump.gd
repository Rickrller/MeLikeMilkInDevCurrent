extends multistate

@export var jumpmult : int = 1

func Enable():
	player.velocity.y = player.jump_velocity * jumpmult
	eventbus.switch_activity.emit(self, "disable")
