extends CharacterBody3D
@export_group("Settings")

@export var pitch_min: float = 0.8
@export var pitch_max: float = 1.2

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
@onready var camera := $Neck/CameraBobber/CameraShaker/Camera3D
@onready var handstate := $handstatemachine
@onready var punchcheck = $Neck/CameraBobber/punchcheck
@onready var parrycooldownnode = $parrycooldown
@onready var iframesnode = $iframes
@onready var punchcooldownnode = $punchcooldown
#@onready var rightarm = $Neck/rightarm/AnimationPlayer
#@onready var leftarm = $Neck/leftarm/AnimationPlayer
@onready var dashdisplay = $Panel/dashcahrges
@onready var anims_R = $Anims/R_AnimationTree["parameters/playback"]
@onready var anims_L = $Anims/L_Animation_Tree["parameters/playback"]
# Jump Variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") + 25
var jump_velocity = 10
@export var max_jumps = 1
@export var coyote_time = 0.3
var coyote_timer = 0.0
var jump_count = 0
var health = 100
var maxhealth = 100

signal parry_ready
signal parry_cast

@onready var PunchVFX = load("res://PunchVFX.tscn")

var _was_on_floor: bool = true

func _ready():
	punchcheck.add_exception(self)
	KillCounter.reset()
	#punchcheck.add_exception($Playercollision)
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
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	if coyote_timer > 0 and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_velocity + 8
		eventbus.switch_activity.emit("jump", "active")
		$Jump.playing = true
		coyote_timer = 0
		ScreenShake.shake_impulse(Vector3.DOWN, 0.4)
	elif jump_count < max_jumps and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_velocity + 8
		$DoubleJump.playing = true
		jump_count += 1
		ScreenShake.shake_impulse(Vector3.DOWN, 0.8)
	if not is_on_floor():
		velocity.y -= gravity * delta
		eventbus.switch_activity.emit("airborne", "active")
		
	else:
		jump_count = 0 
	
	if Input.is_action_just_pressed("shift") and dashcharges >= 1:
		$Dash.playing = true
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
	if is_on_floor() and not _was_on_floor:
		ScreenShake.shake_impulse(Vector3.UP, 1)
		$JumpLand.playing = true
	_was_on_floor = is_on_floor()
	if Input.is_action_pressed("punch") and ispunchready:
		$PunchSwing.pitch_scale = randf_range(pitch_min, pitch_max)
		$PunchSwing.playing = true
		if handstate.current_state.name == "empty":
			punchcooldownnode.wait_time = basepunchCD / stamina
		else:
			punchcooldownnode.wait_time = (2 * basepunchCD) / stamina
		
		if handedness == false: #left hand punch
			#print("left hand punched")
			#rightarm.play("idle")
			punch()
			handedness = true
		elif handedness == true and handstate.current_state.name == "empty": #right hand punch
			#print("right hand punched")
			#leftarm.play("idle")
			punch()
			handedness = false
		elif handedness == true and handstate.current_state.name != "empty": #if right hand is occupied, punch with left instead
			#print("left hand punched due to right hand occupied"
			handedness = false
			punch()
			
		ispunchready = false
		$punchcooldown.start()
	if Input.is_action_just_pressed("parry") and parrycooldown == false:
		$ParryInitiate.playing = true
		ScreenShake.shake_impulse(Vector3.LEFT, 1)
		parrying = true
		parrycooldown = true
		parrycooldownnode.start()
		parry_cast.emit()
		$iframes.stop()
		$iframes.timeout.emit()
		eventbus.Transistioned.emit(handstate.current_state, "parry")
		#rightarm.play("parry")
		#anims_R.start("parry")

func _on_dashcooldown_timeout() -> void:
	#print(dashcharges)
	if dashcharges <= 3:
		dashcharges += 1
	if dashcharges < 3:
		$dashcooldown.start()
	dashdisplay.value = dashcharges
func _on_hurtbox_body_entered(body: Node3D) -> void:
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
			anims_L.start("punch")
		elif animvariant == 1:
			anims_L.start("punch1")
		elif animvariant == 2:
			anims_L.start("punch2")
		elif animvariant == 3:
			anims_L.start("punch3")
		elif animvariant == 4:
			anims_L.start("punch4")
	if handedness == true:
		if animvariant == 0:
			anims_R.start("punch")
		elif animvariant == 1:
			anims_R.start("punch1")
		elif animvariant == 2:
			anims_R.start("punch2")
		elif animvariant == 3:
			anims_R.start("punch3")
		elif animvariant == 4:
			anims_R.start("punch4")
	punchcheck.enabled = true
	punchcheck.force_raycast_update()
	if punchcheck.is_colliding():
		var hit = punchcheck.get_collider()
		if hit != null:
			#print(hit)
			if hit.is_in_group("enemy"):
				hit.health -= basedamage * damagemult
				var PunchVFXInstance = PunchVFX.instantiate()
				PunchVFXInstance.global_transform = %Neck/PunchVFXLocation.global_transform
				get_tree().root.add_child(PunchVFXInstance)
				ScreenShake.shake_simple(0.3, 0.04)
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


func _on_r_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name != "strawberry" and anim_name != "grab":
		anims_R.travel("idle")


func _on_l_animation_tree_animation_finished(_anim_name: StringName) -> void:
	anims_L.travel("idle")
