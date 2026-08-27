extends Node3D
var progress

var scenesloaded = 1.0
@onready var thisscene = get_tree().current_scene
@onready var progressbar = $ProgressBar
var enemies : Array = [load("uid://2k4hx0qjyd3h"), load("uid://buqyie0fr8stu"), load("uid://u1ean8an17tk"),\
 load("uid://cjis0enmu1243"), load("uid://dmidhahr23ew3"), load("uid://dm75h6sa1wvaj"), load("uid://dah08t6ttiajt"), load("uid://dl0gfhs3klsbs"), load("uid://r4ify3rkpjl0"),\
 load("uid://bq67rk83banep"), load("uid://bv3ddxucnf4rq")]
var effects : Array = [load("res://AloeAbility.tscn"), load("res://AppleHit.tscn"), load("res://AppleFistPlayer.tscn"), load("res://DurianCloud.tscn"), load("res://ParryBlueVFX.tscn"), load("res://PunchVFX.tscn")]
var playerscenes : Array = [load("uid://cl8ku5hhn6jv3"), load("uid://xk2j588d8c7o"), load("uid://biy5cxl3wcx4u"), load("uid://cknxkcdlf0md1"), load("uid://ccbwj2fb2o1yt"),\
 ]
var enemyscenes : Array = [load("uid://dc1babpphgfai"), load("uid://g0c74llc3w1q"), load("uid://b16eqne2tquov"), load("uid://dgq8vrvyli2rg")]
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
	
	
	
