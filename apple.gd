extends State
@onready var superpunch = load("res://superpunch.tscn")
@onready var player = $"../.."
@onready var camera = %Camera3D
@onready var rootnodeofscene = get_tree().current_scene
@onready var neck = $"../../Neck"
@onready var nutrition = $"../../nutrition"
const applemesh = preload("res://meshes/applemesh.tscn")
func Enter():
	#print('apple entered')
	var inst = applemesh.instantiate()
	fruitmesh.mesh = inst.mesh
	print(fruitmesh)
	
	
func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("ability"):
		ability()
	if Input.is_action_just_pressed("eat"):
		eat()
func ability():
	$"../../Neck/arm2/AnimationPlayer".play("crush")
	var instance = superpunch.instantiate()
	get_tree().root.add_child(instance)
	
	instance.damagemult = player.damagemult
	instance.global_position.x = player.position.x# * camera.direction.x 
	instance.global_position.z = player.position.z #+ 2
	instance.global_position.y = player.position.y
	instance.global_rotation = neck.global_rotation
	instance.global_position += 2 * camera.direction
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
func eat():
	nutrition.hydration += 17
	nutrition.carbs += 20
	nutrition.vitamins += 2
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	
