extends RigidBody3D
@export var health = 50
@export var damage = 15
@export var push_force: float = 40.0
@export var speed: float = 20.0 #maximum speed
@export var gettingparried = false
enum Estate {idle, blasted, lookingforplayer}
@export var state : Estate = Estate.lookingforplayer
@onready var player: Node3D = null
@onready var direction: Vector3
@onready var ParryVFX = load("res://ParryBlueVFX.tscn")
@export var givenfruit : String
@export var is_in_range : bool
@export var sightrange : float = 30


func _ready() -> void:
	linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	#linear_velocity.y = -1
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("Error locating player")

func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	if not player:
		return
	if state == Estate.lookingforplayer:
		return
		#linear_velocity.x = lerp(linear_velocity.x, 0.0, 0.2)
		#linear_velocity.z = lerp(linear_velocity.z, 0.0, 0.2)
		#angular_velocity = angular_velocity.lerp(Vector3(0,angular_velocity.y,0), 0.2)
		
		
	direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	direction = direction.normalized()
	apply_central_force(direction * push_force)
	var horizontal_velocity := Vector3(linear_velocity.x, 0.0, linear_velocity.z)
	if horizontal_velocity.length() > speed and gettingparried == false:
		horizontal_velocity = horizontal_velocity.normalized() * speed
		linear_velocity.x = horizontal_velocity.x
		linear_velocity.z = horizontal_velocity.z

func _physics_process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 6 == 0:
		checkforplayer()
	if health <= 0:
		queue_free()
		eventbus.grantitem.emit(givenfruit)
	
func parried():
	health -= eventbus.parrydamage
	if health <= 0:
		eventbus.parrykill.emit()
	
	
	look_at(player.global_position)
	var ParryVFXInstance = ParryVFX.instantiate()
	ParryVFXInstance.global_transform = self.global_transform
	get_tree().root.add_child(ParryVFXInstance)
	state = Estate.blasted
	linear_velocity.y += 3
	linear_velocity.z -= 50 * direction.z
	linear_velocity.x -= 50 * direction.x
	await get_tree().create_timer(0.4).timeout
	state = Estate.idle
	
func checkforplayer():
	if not player:
		return
	if self.global_position.distance_to(player.global_position) < sightrange:
		state = Estate.idle
		linear_damp = 1
		angular_damp = 1
	else:
		state = Estate.lookingforplayer
		if linear_velocity.y == 0:
			linear_damp = 2
			angular_damp = 1.5
		
