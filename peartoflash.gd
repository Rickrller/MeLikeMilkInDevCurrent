extends State
@onready var player = $"../.."
@onready var nutrition = $"../../nutrition"
const peartomesh = preload("res://meshes/peartomesh.tscn")
var timestop = preload("res://timestop.tscn")
var flashready = true

func Enter():
	var inst = peartomesh.instantiate()
	fruitmesh.mesh = inst.mesh

func _ready():
	eventbus.connect("flashbang", on_pearto_flash)

func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("eat"):
		eat()
	if Input.is_action_just_pressed("ability"):
		ability()


func eat():
	nutrition.hydration += 4
	nutrition.carbs += 5
	nutrition.vitamins += 14
	nutrition.minerals += 11
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""

func on_pearto_flash():
	
	if flashready:
		flashready = false
		$"../../peartoflash".visible = true
		$"../../peartoflash".modulate = Color(1.0, 1.0, 1.0, 1.0)
		var tween = get_tree().create_tween()
		tween.tween_property($"../../peartoflash", "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.5)
		await get_tree().create_timer(2).timeout
		flashready = true
		$"../../peartoflash".visible = false
		
	
func ability():
	anims.start("crush")
	var instance = timestop.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = player.global_position
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
