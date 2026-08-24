extends multistate


var dash = 30.0
var frames : int
var t

func Enable():
	frames = 12
	
func Physics_Update(delta: float):
	if player:
		t = delta
		if player and frames > 0:
			player.velocity.z = dash * player.direction.z
			player.velocity.x = dash * player.direction.x
			frames -= 1
			#print(frames)
		else:
			eventbus.switch_activity.emit(self, "disable")
