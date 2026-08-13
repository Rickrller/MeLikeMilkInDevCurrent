extends CharacterBody3D
signal Gamble
@export_group("Settings")
@export var speed = 14.0
@export var acceleration = 6.0
@export var friction = 5.0
@export var mouse_sensitivity = 0.004
var gamblecooldown = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
#gamble limits
var maxstrength = 5.0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Health/gamblemeter.play("full")
func _input(event):
	# Toggle Mouse Lock
	if event.is_action_pressed("ui_select"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _unhandled_input(event):
	# FIX: Only rotate if the mouse is captured AND moving
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# Rotate the whole body for left/right
			rotate_y(-event.relative.x * mouse_sensitivity)
			# Rotate ONLY the neck for up/down
			neck.rotate_x(-event.relative.y * mouse_sensitivity)
			# Clamp to prevent backflips
			neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# Gravity logic
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Movement logic
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)
	

	move_and_slide()
