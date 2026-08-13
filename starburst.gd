extends State

@onready var nutrition = $"../../nutrition"
@onready var player = $"../.."
func Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 35
	nutrition.vitamins += 35
	nutrition.minerals += 35
	nutrition.protien += 35
	nutrition.carbs += 35
	eventbus.Transistioned.emit(self, "empty")  
	$"..".currentfruit = ""

func ability():
	var resetspeed = player.speed
	var resetcd = player.basepunchCD
	player.speed += 10
	player.basepunchCD /= 3
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	await get_tree().create_timer(5).timeout
	player.speed = resetspeed
	player.basepunchCD = resetcd
	
