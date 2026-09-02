extends State
const orangemesh = preload("res://meshes/orangemesh.tscn")
@onready var player = $"../.."
@onready var shot = load("res://citruscannonade.tscn")
@onready var neck = $"../../Neck"
@onready var nutrition = $"../../nutrition"
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func Enter():
	used = false
	print("orange fruit gotten")
	var inst = orangemesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()
func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability") and not used:
		ability()
		used = true
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	rightarm.material_overlay.albedo_color = Color("ff885e")
	handstate.locked = true
	anims.start("orange")
	#print("abillity orange yaya")
	var instance = shot.instantiate()
	instance.pos = neck.global_position
	instance.dir = neck.global_rotation
	#get_tree().current_scene.add_child(instance)
	add_child(instance)
	await instance.tree_exiting
	handstate.locked = false
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
	rightarm.material_overlay.albedo_color = handstate.normalalbedo
func eat():
	$"../FruitEat".playing = true
	anims.start("idle")
	nutrition.hydration += 10
	nutrition.minerals += 30
	nutrition.carbs += 12
	nutrition.vitamins += 40
	nutrition.minerals += 12
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
