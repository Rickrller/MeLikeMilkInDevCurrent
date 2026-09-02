extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
@onready var jumpnode = $"../../movementstatemachine/jump"
const jellyjamslam = preload("res://jellyjamslaminst.tscn")
@export var slammin : bool = false
const strawberrymesh = preload("res://meshes/strawberrymesh.tscn")

func Enter():
	used = false
	var inst = strawberrymesh.instantiate()
	fruitmesh.mesh = inst.mesh
	inst.free()
func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability") and not used:
		ability()
		used = true
	if slammin:
		if player.is_on_floor():
			anims.start("slam")
			print("yes")
			slammin = false
			var instance = jellyjamslam.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = player.global_position
			handstate.locked = false
			eventbus.Transistioned.emit(self, "empty")
			handstate.currentfruit = ""
			

func eat():
	anims.start("idle")
	nutrition.hydration += 24
	nutrition.carbs += 70
	nutrition.vitamins += 45
	nutrition.protien += 12
	eventbus.Transistioned.emit(self, "empty")
	handstate.currentfruit = ""

func ability():
	handstate.locked = true
	anims.start("strawberry")
	
	jumpnode.jumpmult *= 3
	eventbus.switch_activity.emit("jump", "active")
	
	player.jump_count = 3
	jumpnode.jumpmult /= 3
	await get_tree().create_timer(1).timeout
	slammin = true
	
	player.velocity.y -= 70
	
	
