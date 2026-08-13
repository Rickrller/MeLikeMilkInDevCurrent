extends State

@onready var nutrition = $"../../nutrition"
var flashready = true
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
	eventbus.Transistioned.emit(self, "empty")
	$"..".currentfruit = ""
