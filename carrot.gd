extends RigidBody3D
@export var damage = 30
@export var health = 35
@export var push_force: float = 45.0
@export var speed: float = 10 #max speed
@export var gettingparried = false
@export var velocity : Vector3
@export var direction : Vector3
@onready var player : Node3D = null
@onready var ParryVFX = load("res://ParryBlueVFX.tscn")
@export var givenfruit : String

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("Error locating player")

func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	if player:
		
		direction = global_position.direction_to(player.global_position)
		apply_central_force(direction * push_force)
		velocity = Vector3(linear_velocity.x, linear_velocity.y, linear_velocity.z)
		if velocity.length() > speed and gettingparried == false:
			velocity = velocity.normalized() * speed
			linear_velocity.x = lerp(linear_velocity.x,velocity.x, 0.25)
			linear_velocity.z = lerp(linear_velocity.z,velocity.z, 0.25)
			linear_velocity.y = lerp(linear_velocity.y,velocity.y, 0.25)
		#angular_damp = 10000000

func _physics_process(_delta: float) -> void:
		if health <= 0:
			eventbus.grantitem.emit(givenfruit)
			queue_free()
		#if Engine.get_frames_drawn() % 2 == 0:

func parried():
	health -= eventbus.parrydamage
	if health <= 0:
		eventbus.parrykill.emit()
		eventbus.grantitem.emit(givenfruit)
	var dir = player.camera.direction
	var ParryVFXInstance = ParryVFX.instantiate()
	ParryVFXInstance.global_transform = self.global_transform
	get_tree().root.add_child(ParryVFXInstance)
	
	gettingparried = true
	linear_velocity.y += 3
	
	linear_velocity += 60 * dir

	await get_tree().create_timer(1).timeout
	gettingparried = false
