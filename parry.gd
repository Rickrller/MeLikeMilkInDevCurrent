extends State
@onready var instantiatedparry = load("res://parry.tscn")
@onready var player = $"../.."
@onready var duration = $duration



func _ready():
	eventbus.parrykill.connect(grab)
func Enter():
	duration.wait_time = 0.25
	clear()
	duration.start()
	var instance = instantiatedparry.instantiate()
	add_child(instance)
	instance.global_position = player.global_position
	
	

func _on_duration_timeout() -> void:
	player.parrying = false
	clear()
	if $"..".currentfruit != "":
		eventbus.Transistioned.emit(self, $"..".currentfruit)
		return
	else:
		eventbus.Transistioned.emit(self, "empty")
	
func clear():
	for child in get_children():
		if child.is_class("Area3D"):
			child.queue_free()

func grab():
	$"../../Neck/arm2/AnimationPlayer".play("grab")
