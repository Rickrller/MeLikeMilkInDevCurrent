extends CharacterBody3D
@export var parent : Node
@onready var player: Node3D = get_tree().get_first_node_in_group("player")
const speed : float = 26.0
var dir : Vector3
var health : float
@export var active : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	getplayer()
	active = true

func getplayer():
	active = true
	dir = global_position.direction_to(player.global_position)
	look_at(player.global_position)
#	parried()
func _physics_process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 5 == 0:
		if not active:
			return
	velocity = dir * speed
	move_and_slide()

func parried():
	global_position = parent.global_positon
	active = false
