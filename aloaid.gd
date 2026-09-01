extends State
const aloemesh = preload("res://meshes/aloemesh.tscn")
@onready var nutrition = $"../../nutrition"
@onready var VFX = load("res://AloeAbility.tscn")
func Enter():
	var inst = aloemesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 50
	nutrition.vitamins += 27
	nutrition.minerals += 19
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	$"../..".health += 5
	
func ability():
	anims.start("crush")
	var VFXInstance = VFX.instantiate()
	VFXInstance.global_transform = get_parent().get_parent().global_transform
	get_tree().root.add_child(VFXInstance)
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	var count = 10
	for i in count:
		$"../..".health += 4
		$"../..".health = ceil($"../..".health)
		await get_tree().create_timer(0.5).timeout
		
