extends State
@onready var handstate = $".."

func Enter():
	handstate.currentfruit = ""
	fruitmesh.mesh = null
	handstate.locked = false
