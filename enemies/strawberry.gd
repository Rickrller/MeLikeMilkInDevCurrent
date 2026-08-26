extends CharacterBody3D
enum enemystate {pouncestart, pouncing, parrying, everythingelse, blasted, attacking}
@export var state : enemystate = enemystate.everythingelse
@export var damage : float
@export var health : float
@export var speed : float
@export var fallspeed = ProjectSettings.get_setting("physics/3d/default_gravity") + 25
@export var pounce_available = true
@export var ispouncing : bool = false
@export var direction : Vector3 
@onready var player: Node3D = null
@export var pouncerange : float
@export var pounceforce : float
@export var givenfruit : String
@onready var ParryVFX = load("res://ParryBlueVFX.tscn")
@export var sightrange : float
@export var attackready : bool = false
@onready var attackcooldown = $Timer2
@export var distancetoplayer : float
@export var diff : Vector3
@onready var area = $Area3D
@export var parryable = false
@onready var model = $model
const parrycolor = Color(0.0, 3.294, 3.294, 0.039)


func _ready() -> void:
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("Error locating player")
	attackcooldown.start()


func _physics_process(delta: float) -> void:
	if parryable:
		model.material_overlay.albedo_color = parrycolor
	else:
		model.material_overlay.albedo_color = Color(1.0, 1.0, 1.0, 0.0)
	
	if Engine.get_frames_drawn() % 5 == 0: #optimization shii
		distancetoplayer = global_position.distance_to(player.global_position)
		diff = global_position - player.global_position
	
	if health <= 0:
		#eventbus.grantitem.emit(givenfruit)
		queue_free()
	if not is_on_floor():
		velocity.y -= fallspeed * delta
	
	
	
	if state == enemystate.everythingelse:
		everythingelse(delta)
	elif state == enemystate.pouncestart:
		pounce()
	elif state == enemystate.pouncing:
		pouncing()
	elif state == enemystate.blasted:
		blasting()
	elif state == enemystate.attacking:
		windup(delta)
			
func pounce():
	state = enemystate.pouncing
	
	
	pounce_available = false
	velocity.y += 30
	await get_tree().physics_frame
	pouncing()
	$Timer.start()
	await get_tree().create_timer(1).timeout
	velocity.y -= 80
	
	
func parried():
	
	if not parryable:
		return
	health -= eventbus.parrydamage
	#if state != enemystate.pouncing and state != enemystate.attacking:
	#	return
	#print("got parried")
	velocity.y += 15
	move_and_slide()
	var ParryVFXInstance = ParryVFX.instantiate()
	ParryVFXInstance.global_transform = self.global_transform
	get_tree().root.add_child(ParryVFXInstance)
	if health <= 0:
		eventbus.parrykill.emit()
		eventbus.grantitem.emit(givenfruit)
	await get_tree().process_frame
	
	state = enemystate.blasted
	
	
func everythingelse(delta):
	if player:
		parryable = false
		if (diff.x * diff.x + diff.z * diff.z) < 16:
			velocity.z = lerp(velocity.z, 0.0, 0.1)
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			#direction.y = 0.0
			lookatplayer(delta)
			if attackready == true:
				state = enemystate.attacking
				
			move_and_slide()
			return
			
		if distancetoplayer < sightrange:
			
			lookatplayer(delta)
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
			
	
	
	if distancetoplayer < pouncerange:
		if pounce_available == true and is_on_floor()  and self.global_position.distance_to(player.global_position) < 25:
			state = enemystate.pouncestart
				
	

	move_and_slide()
	if state == enemystate.blasted:
		if is_on_floor() or is_on_wall():
			state = enemystate.everythingelse








func blasting():
	#print(state)

	state = enemystate.blasted
	
	velocity.z = direction.z * -50
	velocity.x = direction.x * -50
	move_and_slide()
	if is_on_floor() or is_on_wall():
		state = enemystate.everythingelse

func pouncing():
	parryable = true
	state = enemystate.pouncing
	velocity.z = direction.z * pounceforce
	velocity.x = direction.x * pounceforce
	move_and_slide()
	if is_on_floor():
		state = enemystate.everythingelse
		area.monitoring = true
		$Area3D/CollisionShape3D.set_deferred("disabled", false)
		area.global_position = global_position
		deactivatearea()

func windup(delta):
	if distancetoplayer > 7:
		state = enemystate.everythingelse
		#print("failed attack")
		return
	if attackready:
		attackready = false
		attack()
		$Timer2.start()
	
	
	lookatplayer(delta)
	velocity.z = lerp(velocity.z, 0.0, 0.1)
	velocity.x = lerp(velocity.x, 0.0, 0.1)
	
	move_and_slide()

func attack():
	
	$AnimationPlayer.play("attack")
	await get_tree().create_timer(0.1).timeout
	parryable = true
	await get_tree().create_timer(0.3).timeout
	parryable = false
	if distancetoplayer > 7:
		state = enemystate.everythingelse
		$AnimationPlayer.stop()
		
		#print("cooldown")
		return
#	$AnimationPlayer.play("attack")
	if state != enemystate.blasted and state != enemystate.parrying:
		player.getraped(damage)
		
		#print("cooldown")



func _on_timer_timeout() -> void:
	pounce_available = true

func lookatplayer(delta):
	var target_pos : Vector3 = player.position
	var target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	var target_quaternion = target_transform.basis.get_rotation_quaternion()
	
	var start_quaternion = Quaternion(global_transform.basis)
	
	var changed_quaternion = start_quaternion.slerp(target_quaternion, delta * 5)
	global_transform.basis = Basis(changed_quaternion)
	
	#var tween = create_tween()
	#tween.tween_property(self, "quaternion", target_quaternion, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_timer_2_timeout() -> void:
	attackready = true

func deactivatearea():
	await get_tree().create_timer(0.1).timeout

	area.monitoring = false
	$Area3D/CollisionShape3D.set_deferred("disabled", true)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.velocity.y += 20
		body.health -= 10 * body.defense
