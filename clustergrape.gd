extends CharacterBody3D

var check : bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") + 25
@onready var childrenpos : Array = [$grape.global_position, $grape2.global_position, $grape3.global_position, $grape4.global_position]
@onready var collisionshapes : Array = [$grape/CollisionShape3D, $grape2/CollisionShape3D, $grape3/CollisionShape3D, $grape4/CollisionShape3D, $grape2/AOE/CollisionShape3D, $grape3/AOE/CollisionShape3D, $grape4/AOE/CollisionShape3D]
@onready var children : Array = [$grape, $grape2, $grape3, $grape4]

@onready var VFX = load("res://GrapeVFX.tscn")

func _ready() -> void:
	velocity.y += 10

func _physics_process(delta: float) -> void:
	#childrenpos = [$grape.global_position, $grape2.global_position, $grape3.global_position, $grape4.global_position]
	if is_on_floor() and check:
		$AOE/CollisionShape3D.disabled = false
		explode()
		check = false
	else:
		velocity.y -= gravity * delta
		move_and_slide()

func explode():
	var VFXInstance = VFX.instantiate()
	VFXInstance.global_transform = global_transform
	get_tree().root.add_child(VFXInstance)
	childrenpos = [$grape.global_position, $grape2.global_position, $grape3.global_position, $grape4.global_position]
	var count = 0
	for hitbox in collisionshapes:
		hitbox.disabled = false
	for child in children:
		child.process_mode = Node.PROCESS_MODE_INHERIT 
		child.visible = true
		#print(count)
		remove_child(child)
		get_tree().current_scene.add_child(child)
		child.global_position = childrenpos[count]
		if count <= 2:
			count += 1
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()


func _on_aoe_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("fallentree"):
		body.health -= 15
