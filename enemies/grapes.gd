extends CharacterBody3D

@export var touchedfloor : bool = false
@onready var stuntimer = $stuntimer
@onready var attackcooldown = $Timer2
@export var speed : int = 0
@onready var player : Node3D = get_tree().get_first_node_in_group("player")
@export var health : float
@onready var grapeprojectile = preload("res://enemies/grape.tscn")
@export var fruitgiven : String = "grapes"
@export var child : Node3D
@export var sightrange : float
@export var distancetoplayer : float
@onready var heighvariation = randf_range(0.04,0.06)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():

#	await get_tree().create_timer(1).timeout
	shoot()
	
func shoot():
	var instance = grapeprojectile.instantiate()
	instance.parent = self
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
	instance.global_position += 4 * -global_transform.basis.z.normalized()
	child = instance
	attackcooldown.start()
	
func parried():
	
	die()

func _physics_process(delta: float) -> void:
	child.returnpos = global_position
	child.returnpos += 4 * -global_transform.basis.z.normalized()
	if is_on_floor():
		velocity.y += 20
		touchedfloor = true
	if not is_on_floor() and touchedfloor == false:
		velocity.y -= gravity * delta
	else:
		velocity.y = lerp(velocity.y, 0.0, heighvariation)
	move_and_slide()
	
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
	
	var changed_quaternion = start_quaternion.slerp(target_quaternion, delta * 8)
	global_transform.basis = Basis(changed_quaternion)

func die():
	queue_free()
	child.queue_free()

func _on_timer_timeout() -> void:
	attackcooldown.start()
