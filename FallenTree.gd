extends CharacterBody3D
@export var health : float
@onready var player: CharacterBody3D = null

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
