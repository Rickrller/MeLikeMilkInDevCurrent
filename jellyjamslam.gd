extends State

@onready var nutrition = $"../../nutrition"

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 10
	nutrition.carbs += 12
	nutrition.vitamins += 10
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""

func ability():
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
