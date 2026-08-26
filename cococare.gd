extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
const coconutmesh = preload("res://meshes/coconutmesh.tscn")
func Enter():
	print("coconut gotten")
	var inst = coconutmesh.instantiate()
	fruitmesh.mesh = inst.mesh


func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability"):
		ability()
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	anims.start("crush")
	player.basedefense *= 2
	print(player.basedefense)
	print(player.defense)
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	await get_tree().create_timer(6).timeout
	#$Timer.start()
	player.basedefense /= 2
func eat():
	nutrition.hydration += 30
	nutrition.protien += 20
	nutrition.minerals += 13
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
