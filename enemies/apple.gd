extends CharacterBody3D
enum enemystate {parrying, everythingelse, blasted, attacking}
@export var state : enemystate = enemystate.everythingelse
@export var damage : float
@export var health : float
@export var speed : float
@export var fallspeed = ProjectSettings.get_setting("physics/3d/default_gravity") + 25
@export var direction : Vector3 
@onready var player: CharacterBody3D = null
@export var attackdir : Vector3
@export var givenfruit : String
@onready var ParryVFX = load("res://ParryBlueVFX.tscn")
@onready var AppleVFX = load("res://AppleHit.tscn")
@export var sightrange : float
@export var attackready : bool = false
@onready var punch = preload("res://enemies/applepunch.tscn")
@onready var attackcooldown = $Timer2
@export var diff : Vector3
@export var distancetoplayer : float

signal defeated

func _ready() -> void:
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("Error locating player")
	attackcooldown.start()

func _physics_process(delta: float) -> void:
	if state == enemystate.everythingelse:
		everythingelse(delta)
	elif state == enemystate.attacking:
		attacking(delta)
	elif state == enemystate.blasted:
		blasting()
		move_and_slide()
	
	
	
	
	if Engine.get_frames_drawn() % 5 == 0:
		diff = global_position - player.global_position
		distancetoplayer = global_position.distance_to(player.global_position)
	if health <= 0:
		#eventbus.grantitem.emit(givenfruit)
		defeated.emit()
		queue_free()
	if not is_on_floor():
		velocity.y -= fallspeed * delta

	
	
	
	
func parried():
	if not state == enemystate.attacking:
		return
	health -= eventbus.parrydamage
	#print("parry initiated")
	if health <= 0:
		eventbus.parrykill.emit()
		eventbus.grantitem.emit(givenfruit)
	velocity.y += 15
	await get_tree().physics_frame
	await get_tree().physics_frame
	state = enemystate.parrying
	var ParryVFXInstance = ParryVFX.instantiate()
	ParryVFXInstance.global_transform = self.global_transform
	get_tree().root.add_child(ParryVFXInstance)

	blasting()
	
	


func blasting():
	#print(state)

	state = enemystate.blasted
	
	velocity.z = direction.z * -50
	velocity.x = direction.x * -50
	move_and_slide()
	if is_on_floor() or is_on_wall():
		state = enemystate.everythingelse


func everythingelse(delta):
	if player:
		lookatplayer(delta)
		if (diff.x * diff.x + diff.z * diff.z) < 16:
			velocity.z = lerp(velocity.z, 0.0, 0.1)
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			#direction.y = 0.0
			
			if attackready == true:
				$windup.start()
				state = enemystate.attacking
				
			move_and_slide()
			return
		if distancetoplayer < sightrange:
			
			direction = global_position.direction_to(player.global_position)
			direction.y = 0.0
			direction = direction.normalized()
			velocity.z = lerp(velocity.z, direction.z * speed, 0.03)
			velocity.x = lerp(velocity.x, direction.x * speed, 0.03)
			#velocity.x = direction.x * speed
			#velocity.z = direction.x * speed
		else: 
			direction.y = 0.0
			velocity.z = lerp(velocity.z, 0.0, 0.1)
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			#if Engine.get_process_frames() % 2 == 0:
			
	move_and_slide()
	if state == enemystate.blasted:
		if is_on_floor() or is_on_wall():
			state = enemystate.everythingelse
			#print("basicenemystate", state)
			




func attacking(delta):
	if not (diff.x * diff.x + diff.z * diff.z) < 16:
		state = enemystate.everythingelse
	#print("in attacking state")
	attackready = false
	lookatplayer(delta)
	velocity.z = lerp(velocity.z, 0.0, 0.1)
	velocity.x = lerp(velocity.x, 0.0, 0.1)
	
	move_and_slide()


func lookatplayer(delta):
	var target_pos : Vector3 = player.position
	var target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	var target_quaternion = target_transform.basis.get_rotation_quaternion()
	
	var start_quaternion = Quaternion(global_transform.basis)
	
	var changed_quaternion = start_quaternion.slerp(target_quaternion, delta * 2.5)
	global_transform.basis = Basis(changed_quaternion)
	
	#var tween = create_tween()
	#tween.tween_property(self, "quaternion", target_quaternion, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_timer_2_timeout() -> void:
	attackready = true


func _on_windup_timeout() -> void:
	if distancetoplayer < 7:
		#print("attackple")
		var instance = punch.instantiate()
		instance.parent = self
		get_tree().current_scene.add_child(instance)
		attackdir = -global_transform.basis.z.normalized()
		instance.global_position = global_position
		instance.global_position += 2 * attackdir
		var AppleAttackInstance = AppleVFX.instantiate()
		AppleAttackInstance.global_transform = self.global_transform
		get_tree().root.add_child(AppleAttackInstance)
	state = enemystate.everythingelse
	$Timer2.start()
