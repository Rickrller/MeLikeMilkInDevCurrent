extends State
const starfruitmesh = preload("res://meshes/starfruitmesh.tscn")
@onready var nutrition = $"../../nutrition"
@onready var player = $"../.."
@onready var leftarm = $"../../Neck/CameraBobber/leftarm/metarig/Skeleton3D/Cube_001"
const starcolor = Color("ffe091")
func Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()

func Enter():
	var inst = starfruitmesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()
func eat():
	nutrition.hydration += 35
	nutrition.vitamins += 35
	nutrition.minerals += 35
	nutrition.protien += 35
	nutrition.carbs += 35
	eventbus.Transistioned.emit(self, "empty")  
	handstate.currentfruit = ""

func ability():
	anims.start("crush")
	player.speed += 10
	player.basepunchCD /= 3
	$"../../movementstatemachine/airborne".longjumpspeed += 12
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""
	rightarm.material_overlay.albedo_color = starcolor
	leftarm.material_overlay.albedo_color = starcolor
	handstate.normalalbedo = starcolor
	await get_tree().create_timer(5).timeout
	if handstate.normalalbedo == starcolor:
		handstate.normalalbedo = Color(0.0, 0.0, 0.0, 0.0)
	if rightarm.material_overlay.albedo_color == starcolor:
		rightarm.material_overlay.albedo_color = Color(0.0, 0.0, 0.0, 0.0)
		leftarm.material_overlay.albedo_color = Color(0.0, 0.0, 0.0, 0.0)
		
	player.speed -= 10
	player.basepunchCD *= 3
	$"../../movementstatemachine/airborne".longjumpspeed -= 12
