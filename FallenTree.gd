extends CharacterBody3D
@export var health : float = 200
@onready var player: CharacterBody3D = null
var has_exploded: bool = false

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(_delta: float) -> void:
	if health <= 0 and not has_exploded:
		has_exploded = true
		%TreeExplode.playing = true
		$Hitbox.disabled = true
		$Trunk.visible = false
		$SmokeBig.emitting = true
		$SmokeBigFast.emitting = true
		$Pieces.emitting = true
