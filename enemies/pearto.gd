extends CharacterBody3D
enum enemystate { parrying, everythingelse, blasted, attacking}
@export var state : enemystate = enemystate.everythingelse
@export var damage : float
@export var health : float
@export var speed : float
@export var fallspeed = ProjectSettings.get_setting("physics/3d/default_gravity") + 25
@export var direction : Vector3 
@onready var player: Node3D = null
@export var givenfruit : String
@onready var ParryVFX = load("res://ParryBlueVFX.tscn")
@export var sightrange : float
@export var attackready : bool = false
@onready var attackcooldown = $Timer2
@export var distancetoplayer : float = INF
@export var diff : Vector3
const parrycolor = Color(3.294, 3.294, 3.294, 0.039)
@export var normal_albedo : Color = Color(0.0, 0.0, 0.0, 0.0)
@onready var model = $model
@onready var anims = $AnimationPlayer
func _ready() -> void:

		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
	#	else:
	#		push_error("Error locating player")
		attackcooldown.start()
	#	distancetoplayer = global_position.distance_to(player.global_position)
	#	diff = global_position - player.global_position

func _physics_process(delta: float) -> void:
	if state == enemystate.blasted:
		blasting()
	if Engine.get_frames_drawn() % 5 == 0: #optimization shii
		distancetoplayer = global_position.distance_to(player.global_position)
		diff = global_position - player.global_position
	if distancetoplayer < sightrange:
		lookatplayer(delta)
	if health <= 0:
		KillCounter.register_kill()
		#eventbus.grantitem.emit(givenfruit)
		queue_free()
	if not is_on_floor():
		velocity.y -= fallspeed * delta
	if distancetoplayer <= 7:
		model.material_overlay.albedo_color = parrycolor
	else:
		model.material_overlay.albedo_color = normal_albedo
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
				anims.play("attack")
				
			
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
			


	move_and_slide()
	if state == enemystate.blasted:
		if is_on_floor() or is_on_wall():
			state = enemystate.everythingelse
			#print("basicenemystate", state)

func parried(d : bool, k : bool, v : bool):
	if d:
		health -= eventbus.parrydamage
	if health <= 0:
		eventbus.parrykill.emit()
		eventbus.grantitem.emit(givenfruit)
	
	#print("parry initiated")
	if k:
		state = enemystate.parrying
		velocity.y += 15
	if v:
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


func attack():
	eventbus.flashbang.emit()
	$Timer2.start()
