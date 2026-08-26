extends State
const lemonmesh = preload("res://meshes/lemonmesh.tscn")
@onready var nutrition = $"../../nutrition"
@onready var soursplash = preload("res://enemies/lemonpuddle.tscn")
@onready var player = $"../.."

func Enter():
	var inst = lemonmesh.instantiate()
	fruitmesh.mesh = inst.mesh


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
	var instance = soursplash.instantiate()
	instance.target_type = "enemy"
	get_tree().current_scene.add_child(instance)
	instance.global_position = player.global_position
	anims.start("lemon")
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
