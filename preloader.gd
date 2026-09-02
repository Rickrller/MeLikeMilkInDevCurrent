extends Node3D
var progress

var scenesloaded = 1.0
@onready var thisscene = get_tree().current_scene
@onready var progressbar = $ProgressBar
var enemies : Array = [load("res://enemies/aloevera.tscn"), load("res://enemies/apple.tscn"), load("res://enemies/carrot.tscn"),\
 load("res://enemies/coconut.tscn"), load("res://enemies/durian.tscn"), load("res://enemies/grapes.tscn"), load("res://enemies/lemon.tscn"), load("res://enemies/orange.tscn"), load("res://enemies/pearto.tscn"),\
 load("res://enemies/starfruit.tscn"), load("res://enemies/strawberry.tscn")]
var effects : Array = [load("res://AloeAbility.tscn"), load("res://AppleHit.tscn"), load("res://AppleFistPlayer.tscn"), load("res://DurianCloud.tscn"), load("res://ParryBlueVFX.tscn"), load("res://PunchVFX.tscn"), load("res://CarrotnadoVFX.tscn")]
var playerscenes : Array = [load("res://carrotnado.tscn"), load("res://citruscannonade.tscn"), load("res://jellyjamslaminst.tscn"), load("res://parry.tscn"), load("res://superpunch.tscn"),\
 ]
var enemyscenes : Array = [load("res://enemies/applepunch.tscn"), load("res://enemies/duriansmoke.tscn"), load("res://enemies/lemonpuddle.tscn"), load("res://clustergrape.tscn")]
var totalscenes = enemies.size() + effects.size() + playerscenes.size() + enemyscenes.size() + 1

func _ready() -> void:
	Engine.max_fps = 60
	print(totalscenes)
	for enemy in enemies:
		milk(enemy)
	for effect in effects:
		milk(effect)
	for scene in playerscenes:
		milk(scene)
	for scene in enemyscenes:
		milk(scene)
	
	
func milk(tscn):
	var inst = tscn.instantiate()
	var extra_wait = false
	if inst.has_node("CollisionShape3D"):
		inst.get_node("CollisionShape3D").set_deferred("disabled", true)
	if inst.has_node("Area3D"):
		inst.get_node("Area3D").set_deferred("monitoring", false)
	if inst is CPUParticles3D or not inst.find_children("*", "CPUParticles3D", true, false).is_empty():
		extra_wait = true
	print(extra_wait)
	thisscene.add_child(inst)
	inst.set_physics_process(false)
	
	if not inst.is_node_ready():
		await inst.ready
	if extra_wait == true:
		extra_wait = false
		var count = 60
		for i in count:
			await get_tree().physics_frame
	if inst:
		inst.queue_free()
	scenesloaded += 1.0
	progress = (scenesloaded / totalscenes) * 100

	#print(progress)
	#print(scenesloaded)
func _process(_delta: float) -> void:
	#print(scenesloaded)
	#print(totalscenes)
	progress = (scenesloaded / totalscenes) * 100
	progressbar.value = progress
	if progress == 100:
		get_tree().change_scene_to_file("res://GameMenu.tscn")
	print(progress)
	
	
	
