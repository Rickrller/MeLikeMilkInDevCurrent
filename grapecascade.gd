extends State

@onready var nutrition = $"../../nutrition"


func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 50
	nutrition.vitamins += 27
	nutrition.minerals += 19
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	$"../..".health += 5
	
func ability():
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
