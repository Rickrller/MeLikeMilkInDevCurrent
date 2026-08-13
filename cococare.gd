extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
func Enter():
	print("coconut gotten")



func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability"):
		ability()
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	player.basedefense += 1
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	await get_tree().create_timer(6).timeout
	player.basedefense -= 1

func eat():
	nutrition.hydration += 30
	nutrition.protien += 20
	nutrition.minerals += 13
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
