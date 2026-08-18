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

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("Error locating player")
	attackcooldown.start()

func _physics_process(delta: float) -> void:
	if state == enemystate.blasted:
		blasting()
	if Engine.get_frames_drawn() % 5 == 0: #optimization shii
		distancetoplayer = global_position.distance_to(player.global_position)
		diff = global_position - player.global_position
	if distancetoplayer < sightrange:
		lookatplayer(delta)
	if health <= 0:
		eventbus.grantitem.emit(givenfruit)
		queue_free()
	if not is_on_floor():
		velocity.y -= fallspeed * delta
	
	if player:
		#if sqrt(((global_position.x - player.global_position.x) **2)+(global_position.z - player.global_position.z) ** 2) < 5:
		if (diff.x * diff.x + diff.z * diff.z) < 16:
			
			#print("closetoplayer")
			#direction.y = 0.0
			velocity.z = lerp(velocity.z, 0.0, 0.1)
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			
			
			if attackready == true and state == enemystate.everythingelse and distancetoplayer < 7:
				attackready = false
				state = enemystate.attacking
				player.getraped(damage)
				if self.name == "pear":
					eventbus.flashbang.emit()
				$Timer2.start()
			
			else:
				if state == enemystate.attacking:
					state = enemystate.everythingelse
			move_and_slide()
			return
		if distancetoplayer < sightrange:
			if state == enemystate.everythingelse:
				
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
		if get_node_or_null("Timer"):
			if pounce_available == true and is_on_floor() and state == enemystate.everythingelse and self.global_position.distance_to(player.global_position) < 25:
				pounce()
				
			

	if state == enemystate.pouncing:
		pouncing()
	
	move_and_slide()
	if state == enemystate.pouncing or state == enemystate.blasted:
		if is_on_floor() or is_on_wall():
			state = enemystate.everythingelse
			#print("basicenemystate", state)
			
func pounce():

	if state == enemystate.everythingelse:
		state = enemystate.pouncestart
	else:
		return
	pounce_available = false
	velocity.y += 15
	pouncing()
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

func pouncing():
	state = enemystate.pouncing
	velocity.z = direction.z * pounceforce
	velocity.x = direction.x * pounceforce
	


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
