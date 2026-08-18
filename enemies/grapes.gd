extends CharacterBody3D

@onready var stuntimer = $stuntimer
@onready var attackcooldown = $Timer2
@export var speed : int = 0
@onready var player : Node3D = %Player
@export var health : float
@onready var grapeprojectile = preload("res://enemies/grape.tscn")
@export var fruitgiven : String = "grapes"
@export var child : Node3D
@export var sightrange : float
@export var distancetoplayer : float
func _ready():
	await get_tree().create_timer(1).timeout
	shoot()
	attackcooldown.start()
func shoot():
	var instance = grapeprojectile.instantiate()
	instance.parent = self
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
	child = instance
	
	
func parried():
	
	die()

func _physics_process(delta: float) -> void:
	if Engine.get_frames_drawn() % 5 == 0:
		lookatplayer(delta)
		distancetoplayer = global_position.distance_to(player.global_position)
		if distancetoplayer > sightrange:
			return
			#attackcooldown
			
	if not child:
		return
	if child.active:
		child.physicsgo()
	



func _on_timer_2_timeout() -> void:
	child.reset()
	child.getplayer()
	attackcooldown.start()

func interruption():
	attackcooldown.stop()
	stuntimer.start()

func lookatplayer(delta):
	var target_pos : Vector3 = player.position
	var target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	var target_quaternion = target_transform.basis.get_rotation_quaternion()
	
	var start_quaternion = Quaternion(global_transform.basis)
	
	var changed_quaternion = start_quaternion.slerp(target_quaternion, delta)
	global_transform.basis = Basis(changed_quaternion)

func die():
	queue_free()
	child.queue_free()

func _on_timer_timeout() -> void:
	attackcooldown.start()
