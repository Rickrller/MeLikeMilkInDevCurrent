extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
@onready var neck = $"../../Neck"
var tornado = preload("res://carrotnado.tscn")
const carrotmesh = preload("res://meshes/carrotmesh.tscn")

func Enter():
	print("carrot entered")
	var inst = carrotmesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()
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
	handstate.currentfruit = ""

func ability():
	anims.start("carrot")
	var instance = tornado.instantiate()

	get_tree().current_scene.add_child(instance)
	instance.global_position = player.global_position
	instance.global_rotation = neck.global_rotation
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
