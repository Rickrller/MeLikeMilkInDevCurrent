extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
@onready var leftarm = $"../../Neck/CameraBobber/leftarm/metarig/Skeleton3D/Cube_001"
const coconutmesh = preload("res://meshes/coconutmesh.tscn")
const MILES_THEBLACKONE = Color("61393be0")
func Enter():
	print("coconut gotten")
	var inst = coconutmesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability"):
		ability()
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	rightarm.material_overlay.albedo_color = MILES_THEBLACKONE
	leftarm.material_overlay.albedo_color = MILES_THEBLACKONE
	handstate.normalalbedo = MILES_THEBLACKONE
	anims.start("crush")
	player.basedefense *= 2
	print(player.basedefense)
	print(player.defense)
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
	await get_tree().create_timer(6).timeout
	player.basedefense /= 2
	if handstate.normalalbedo == MILES_THEBLACKONE:
		handstate.normalalbedo = Color(0.0, 0.0, 0.0, 0.0)
	if rightarm.material_overlay.albedo_color == MILES_THEBLACKONE:
		rightarm.material_overlay.albedo_color = Color(0.0, 0.0, 0.0, 0.0)
		leftarm.material_overlay.albedo_color = Color(0.0, 0.0, 0.0, 0.0)
func eat():
	nutrition.hydration += 30
	nutrition.protien += 20
	nutrition.minerals += 13
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
