extends State
const grapemesh = preload("res://meshes/grapemesh.tscn")
@onready var nutrition = $"../../nutrition"
@onready var clustergrape = preload("res://clustergrape.tscn")
@onready var player = $"../.."
@onready var cam = $"../../Neck/Camera3D"
func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 5
	nutrition.vitamins += 10
	nutrition.minerals += 10
	nutrition.carbs += 20
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
	
	
func ability():
	anims.start("grapes")
	await animnode.animation_finished
	var instance = clustergrape.instantiate()

	get_tree().current_scene.add_child(instance)
	instance.global_position = player.global_position
	instance.global_position += 2 * cam.direction
	instance.velocity.x = 10 * cam.direction.x
	instance.velocity.z = 10 * cam.direction.z
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
