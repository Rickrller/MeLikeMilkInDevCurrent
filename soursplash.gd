extends State

@onready var nutrition = $"../../nutrition"

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 5
	nutrition.vitamins += 7
	nutrition.minerals += 18
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""

func ability():
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
