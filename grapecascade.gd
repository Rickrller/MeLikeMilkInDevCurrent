extends State
const grapemesh = preload("res://meshes/grapemesh.tscn")
@onready var nutrition = $"../../nutrition"
@onready var clustergrape = preload("res://clustergrape.tscn")
@onready var player = $"../.."
@onready var cam = $"../../Neck/CameraBobber/CameraShaker/Camera3D"

func Enter():
	used = false
	var inst = grapemesh.instantiate()
	fruitmesh.mesh = inst.mesh

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability") and not used:
		ability()
		used = true


func eat():
	nutrition.hydration += 5
	nutrition.vitamins += 10
	nutrition.minerals += 10
	nutrition.carbs += 20
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	
	
func ability():
	$"..".locked = true
	anims.start("grapes")
	#await animnode.animation_finished
	
func launch():
	var instance = clustergrape.instantiate()

	get_tree().current_scene.add_child(instance)
	instance.global_position = player.global_position
	instance.global_position += 2 * cam.direction
	instance.velocity.x = 10 * cam.direction.x
	instance.velocity.z = 10 * cam.direction.z
	$"..".locked = false
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
