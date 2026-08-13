extends State

@onready var nutrition = $"../../nutrition"

func Enter():
	print("carrot entered")

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()

func eat():
	nutrition.protien += 17
	nutrition.minerals += 1
	nutrition.vitamins += 15
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""

func ability():
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
