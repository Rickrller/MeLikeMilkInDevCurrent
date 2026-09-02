extends State

@onready var nutrition = $"../../nutrition"
@onready var smoke = preload("res://enemies/duriansmoke.tscn")
@onready var player = $"../.."
const durianmesh = preload("res://meshes/durianmesh.tscn")
func Enter():
	var inst = durianmesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability"):
		ability()
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	anims.start("crush")
	var instance = smoke.instantiate()
	get_tree().root.add_child(instance)
	
	instance.target = "enemy"
	instance.global_position = player.global_position
	instance.time = 8
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""

func eat():
	anims.start("idle")
	nutrition.hydration += 10
	nutrition.carbs += 60
	nutrition.vitamins += 10
	nutrition.protien += 30
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
