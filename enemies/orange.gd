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
@export var attackready : bool = true
@onready var attackcooldown = $Timer2

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("Error locating player")

func _physics_process(delta: float) -> void:
	if health <= 0:
		eventbus.grantitem.emit(givenfruit)
		queue_free()
	if not is_on_floor():
		velocity.y -= fallspeed * delta
	
	if self.global_position.distance_to(player.global_position) < pouncerange:
		if get_node_or_null("Timer"):
			if pounce_available == true and is_on_floor() and (state == enemystate.everythingelse or state == enemystate.attacking):
				pounce(delta)
				
			
	if state == enemystate.blasted:
		blasting()
	if state == enemystate.pouncing:
		pouncing(delta)
		#cannonade(1)
	if state == enemystate.attacking:
		lookatplayer(delta, 11)
		
	if player and (state == enemystate.attacking or state == enemystate.everythingelse):
		if sqrt(((global_position.x - player.global_position.x) ** 2) + (global_position.z - player.global_position.z) ** 2) < 15:
			move_and_slide()
			#direction.y = 0.0
			velocity.z = lerp(velocity.z, 0.0, 0.1)
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			
			lookatplayer(delta, 2.5)
			if attackready == true:
				attackready = false
				state = enemystate.attacking
				cannonade(16)
				
				$Timer2.start()
			
			
				
			return
		if global_position.distance_to(player.global_position) < sightrange:
			if state == enemystate.everythingelse:
				lookatplayer(delta, 2.5)
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
	if state == enemystate.pouncing or state == enemystate.blasted:
		if is_on_floor() or is_on_wall():
			state = enemystate.everythingelse
			#print("basicenemystate", state)
			
func pounce(delta):

	if state == enemystate.everythingelse or state == enemystate.attacking:
		state = enemystate.pouncestart
	else:
		return
	pounce_available = false
	velocity.y += 15
	pouncing(delta)
	$Timer.start()
	
	
	
func parried():
	#print("parry initiated")
	state = enemystate.parrying
	velocity.y += 15
	
	var ParryVFXInstance = ParryVFX.instantiate()
	ParryVFXInstance.global_transform = self.global_transform
	get_tree().root.add_child(ParryVFXInstance)
	
	blasting()
	
	


func blasting():
	#print(state)
	if state != enemystate.everythingelse:
		state = enemystate.blasted
	else:
		return
	velocity.z = direction.z * -50
	velocity.x = direction.x * -50
	
func pouncing(delta):
	state = enemystate.pouncing
	velocity.z = direction.z * pounceforce
	velocity.x = direction.x * pounceforce
	lookatplayer(delta, 11)
	#cannonade(1)
	


func _on_timer_timeout() -> void:
	pounce_available = true

func lookatplayer(delta, magnitude):
	var target_pos : Vector3 = player.position
	var target_transform = global_transform.looking_at(target_pos, Vector3.UP)
	var target_quaternion = target_transform.basis.get_rotation_quaternion()
	
	var start_quaternion = Quaternion(global_transform.basis)
	
	var changed_quaternion = start_quaternion.slerp(target_quaternion, delta * magnitude)
	global_transform.basis = Basis(changed_quaternion)
	
	#var tween = create_tween()
	#tween.tween_property(self, "quaternion", target_quaternion, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_timer_2_timeout() -> void:
	
	attackready = true

func cannonade(amount):
	$beam.shoot(amount)
	
