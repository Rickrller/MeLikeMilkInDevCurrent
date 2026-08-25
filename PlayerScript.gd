extends CharacterBody3D
@export_group("Settings")

# Movement Variables
@export var speed = 13.0
@export var acceleration = 6.0
@export var friction = 5.0
@export var mouse_sensitivity = 0.004
@export var direction : = Vector3.ZERO
@export var dashcharges : int = 3
@export var input_dir : Vector2

#combat and other variables
@export var handedness : bool = true #true means right handed, false means left handed
@export var ispunchready : bool = true
@export var parrycooldown : bool = false
@export var parrying : bool = false
@export var basedefense : float = 1.0
@export var basedamage : float = 10.0
#stats affected by nutrition
@export var defense : float = 1.0 #minerals
@export var stamina : float = 1.0 #hydration
@export var speedmult : float = 1.0 #carbs
@export var regen : float = 1.0 #vitamins
@export var damagemult : float = 1.0 #protien
@export var basepunchCD : float = 0.2
@export var defensemult : float = 1.0

# Camera/children Variables
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var handstate := $handstatemachine
@onready var punchcheck = $Neck/punchcheck
@onready var parrycooldownnode = $parrycooldown
@onready var iframesnode = $iframes
@onready var punchcooldownnode = $punchcooldown
@onready var rightarm = $Neck/arm2/AnimationPlayer
@onready var leftarm = $Neck/arm/AnimationPlayer
@onready var dashdisplay = $Panel/dashcahrges

# Jump Variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") + 25
var jump_velocity = 10
@export var max_jumps = 1
var jump_count = 0
var health = 100
var maxhealth = 100

signal parry_ready
signal parry_cast

func _ready():
	punchcheck.add_exception(self)
	#punchcheck.add_exception($Playercollision)
	rightarm.play("idle")
	leftarm.play("idle")
func _unhandled_input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			neck.rotate_x(-event.relative.y * mouse_sensitivity)
			neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 5 == 0 and health > maxhealth:
		health = maxhealth

func _physics_process(delta):
	# Jumping

	if is_on_floor() and Input.is_action_pressed("ui_accept"):
		eventbus.switch_activity.emit("jump", "active")
		jump_count += 1
	elif jump_count < max_jumps and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_velocity + 8
		jump_count += 1
	if not is_on_floor():
		velocity.y -= gravity * delta
		eventbus.switch_activity.emit("airborne", "active")
		
	else:
		jump_count = 0 
	
	if Input.is_action_just_pressed("shift") and dashcharges >= 1:
		eventbus.switch_activity.emit("dashing", "active")
		if dashcharges == 3:
			$dashcooldown.start()
		dashcharges -= 1
		dashdisplay.value = dashcharges


	# Movement
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		eventbus.switch_activity.emit("walking", "active")
	else:
		eventbus.switch_activity.emit("idle", "active")
	
	if health <= 0:
		get_tree().quit()
	else:
		$Panel/Health.text = "Health: " + str(health)
		$Panel/parryavailable.text = "Parry Ready: " + str(!parrycooldown)
	
	
	move_and_slide()
	
	if Input.is_action_pressed("punch") and ispunchready:
		
		if handstate.current_state.name == "empty":
			punchcooldownnode.wait_time = basepunchCD / stamina
		else:
			punchcooldownnode.wait_time = (2 * basepunchCD) / stamina
		
		if handedness == false: #left hand punch
			#print("left hand punched")
			rightarm.play("idle")
			punch()
			handedness = true
		elif handedness == true and handstate.current_state.name == "empty": #right hand punch
			#print("right hand punched")
			leftarm.play("idle")
			punch()
			handedness = false
		elif handedness == true and handstate.current_state.name != "empty": #if right hand is occupied, punch with left instead
			#print("left hand punched due to right hand occupied"
			handedness = false
			punch()
			
		ispunchready = false
		$punchcooldown.start()
	if Input.is_action_just_pressed("parry") and parrycooldown == false:
		parrying = true
		parrycooldown = true
		parrycooldownnode.start()
		parry_cast.emit()
		$iframes.stop()
		$iframes.timeout.emit()
		eventbus.Transistioned.emit(handstate.current_state, "parry")
		rightarm.play("parry")

func _on_dashcooldown_timeout() -> void:
	#print(dashcharges)
	if dashcharges <= 3:
		dashcharges += 1
	if dashcharges < 3:
		$dashcooldown.start()
	dashdisplay.value = dashcharges
func _on_hurtbox_body_entered(body: Node3D) -> void:
	#"""if body.is_in_group("enemy") and parrying == true:
		#body.parried()
		#body.health -= 20
		#health += 5
		
		#punchcooldownnode.stop()
		#punchcooldownnode.timeout.emit()
		#parrycooldownnode.stop()
		#parrycooldownnode.timeout.emit()
		##$hurtbox/PlayerHurtbox.disabled = true
		##iframesnode.start()""" 
	if body.is_in_group("rigidbody") and parrying == false: #elif for stringed out if statement above
		health -= body.damage / defense
		#print(defense)
		$hurtbox/PlayerHurtbox.disabled = true
		$iframes.start()

func _on_punchcooldown_timeout() -> void:
	ispunchready = true
	
func punch():
	
	
	var animvariant = randi_range(0,3)
	if handedness == false:
		if animvariant == 0:
			leftarm.play("punch2")
		elif animvariant == 1:
			leftarm.play("punch1")
		elif animvariant == 2:
			leftarm.play("punch")
		elif animvariant == 3:
			leftarm.play("punch3")
	elif handedness == true:
		if animvariant == 0:
			rightarm.play("punch2")
		elif animvariant == 1:
			rightarm.play("punch1")
		elif animvariant == 2:
			rightarm.play("punch")
		elif animvariant == 3:
			rightarm.play("punch3")
	punchcheck.enabled = true
	punchcheck.force_raycast_update()
	if punchcheck.is_colliding():
		var hit = punchcheck.get_collider()
		if hit != null:
			#print(hit)
			if hit.is_in_group("enemy"):
				hit.health -= basedamage * damagemult
				#print("dealt" + str(basedamage * damagemult) + "damage")
	else:
		#print("nothing hit")
		pass
			
	punchcheck.enabled = false
	


func getraped(dmg):
	if $hurtbox/PlayerHurtbox.disabled == false:
		health -= dmg / defense
		$iframes.start()

func _on_parrycooldown_timeout() -> void:
	parrycooldown = false
	parry_ready.emit()


func _on_iframes_timeout() -> void:
	$hurtbox/PlayerHurtbox.disabled = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "grab" and anim_name != "crush":
		leftarm.play("idle")


func _on_right_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "grab" and anim_name != "crush":
		rightarm.play("idle")
