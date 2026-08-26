extends State
const orangemesh = preload("res://meshes/orangemesh.tscn")
@onready var player = $"../.."
@onready var shot = load("res://citruscannonade.tscn")
@onready var neck = $"../../Neck"
@onready var nutrition = $"../../nutrition"
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func Enter():
	print("orange fruit gotten")
	var inst = orangemesh.instantiate()
	fruitmesh.mesh = inst.mesh
func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability"):
		ability()
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	anims.start("orange")
	#print("abillity orange yaya")
	var instance = shot.instantiate()
	instance.pos = neck.global_position
	instance.dir = neck.global_rotation
	#get_tree().current_scene.add_child(instance)
	add_child(instance)
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""

func eat():
	nutrition.hydration += 10
	nutrition.minerals += 2
	nutrition.carbs += 5
	nutrition.vitamins += 15
	nutrition.minerals += 5
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
