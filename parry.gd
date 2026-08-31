extends State
@onready var instantiatedparry = load("res://parry.tscn")
@onready var player = $"../.."
@onready var duration = $duration
@onready var rightarm = $"../../Anims/R_AnimationTree"["parameters/playback"]
@onready var leftarm = $"../../Anims/L_Animation_Tree"["parameters/playback"]

func _ready():
	eventbus.parrykill.connect(grab)
func Enter():
	if $"..".currentfruit == "":
		rightarm.start("parry")
	else:
		leftarm.start("parry")
	duration.wait_time = 0.25
	clear()
	duration.start()
	var instance = instantiatedparry.instantiate()
	add_child(instance)
	instance.global_position = player.global_position
	#rightarm.material_overlay.albedo_color = Color(0.0, 1.825, 1.825, 0.588)


func _on_duration_timeout() -> void:
	player.parrying = false
	clear()
	if $"..".currentfruit != "":
		eventbus.Transistioned.emit(self, $"..".currentfruit)
		return
	else:
		eventbus.Transistioned.emit(self, "empty")
	#rightarm.material_overlay.albedo_color = Color(1.0, 1.0, 1.0, 0.0)
func clear():
	for child in get_children():
		if child.is_class("Area3D"):
			child.queue_free()

func grab():
	#rightarm.play("grab")
	anims.start("grab")
	pass
func Exit():
	#$"../../Neck/arm2/metarig/Skeleton3D/Cube_001".material_overlay.albedo_color = Color(1.0, 1.0, 1.0, 0.0)
	pass
