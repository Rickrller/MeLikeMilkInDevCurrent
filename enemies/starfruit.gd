extends CharacterBody3D
@onready var player : Node3D = null
@export var touchedfloor : bool = false
@export var health : float
@export var givenfruit : String
@onready var heighvariation = randf_range(0.04,0.06)
@export var distancetoplayer : float
const parrycolor = Color(3.294, 3.294, 3.294, 0.039)
const normal_albedo : Color = Color(0.0, 0.0, 0.0, 0.0)
var buffalbedo = Color(1.873, 1.873, 0.0, 0.3)
@onready var model = $CollisionShape3D/model
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	

var speed = 0
var attackcooldown = {"wait_time" : 0}
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _physics_process(delta: float) -> void:
	if Engine.get_frames_drawn() % 5 == 0:
		distancetoplayer = global_position.distance_to(player.global_position)
	if health <= 0:
		KillCounter.register_kill()
		queue_free()
	if is_on_floor():
		$AnimationPlayer.play("float")
		velocity.y += 20
		touchedfloor = true
	if distancetoplayer <= 7:
		model.material_overlay.albedo_color = parrycolor
	else:
		model.material_overlay.albedo_color = normal_albedo
	if not is_on_floor() and touchedfloor == false:
		velocity.y -= gravity * delta
	else:
		velocity.y = lerp(velocity.y, 0.0, heighvariation)
	move_and_slide()


func _on_buffarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("fallentree") and body != self:
		body.speed *= 2
		body.normal_albedo = buffalbedo
		if not body.is_in_group("rigidbody"):
			body.attackcooldown.wait_time *= 0.75


func _on_buffarea_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("fallentree") and body != self:
		body.speed /= 2
		body.normal_albedo = normal_albedo
		if not body.is_in_group("rigidbody"):
			body.attackcooldown.wait_time /= 0.75


func parried(d : bool, _k : bool, _v : bool):
	if d:
		eventbus.parrykill.emit()
		eventbus.grantitem.emit(givenfruit)
		queue_free()
