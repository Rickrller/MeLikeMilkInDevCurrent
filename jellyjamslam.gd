extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
@onready var jumpnode = $"../../movementstatemachine/jump"
const jellyjamslam = preload("res://jellyjamslaminst.tscn")
@export var slammin : bool = false
func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()
	if slammin:
		if player.is_on_floor():
			anims.start("slam")
			print("yes")
			slammin = false
			var instance = jellyjamslam.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = player.global_position
			eventbus.Transistioned.emit(self, "empty")
			$"..".currentfruit = ""

func eat():
	nutrition.hydration += 10
	nutrition.carbs += 12
	nutrition.vitamins += 10
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""

func ability():
	anims.start("strawberry")
	
	jumpnode.jumpmult *= 3
	eventbus.switch_activity.emit("jump", "active")
	
	player.jump_count = 3
	jumpnode.jumpmult /= 3
	await get_tree().create_timer(1).timeout
	slammin = true
	
	player.velocity.y -= 70
	
	
