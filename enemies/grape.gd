extends CharacterBody3D
@export var parent : Node
@onready var player: Node3D = get_tree().get_first_node_in_group("player")
@onready var collision = $CollisionShape3D
@onready var areacollision = $hitshii/CollisionShape3D
@export var returnpos : Vector3
var speed : float = 60
var dir : Vector3
var health : float = 100
var attackcooldown = {"wait_time" : 0}
const damage = 2
@export var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	getplayer()

func getplayer():
	visible = true
	active = true
	dir = global_position.direction_to(player.global_position)
	look_at(player.global_position)

#func _physics_process(_delta: float) -> void:
	#if Engine.get_frames_drawn() % 2 == 0:
		#if not active:
			#return
	#velocity = dir * speed
	#move_and_slide()
		#pass
func parried():
	if not active:
		parent.die()

		
	parent.interruption()
	reset()

func reset():
	visible = false
	global_position = returnpos
	active = false
	print("i, rick wang, love DIH")

func physicsgo():
	velocity = dir * speed
	move_and_slide()


func _on_hitshii_body_entered(body: Node3D) -> void:
	#print("parent: " + str(parent))
	if body.is_in_group("player"):
		body.health -= damage * body.defense
		parent.interruption()
	reset()
