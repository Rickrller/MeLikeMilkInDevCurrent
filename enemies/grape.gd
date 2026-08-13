extends CharacterBody3D


@export var speed : int = 8
@onready var player: Vector3 #= Vector3.ZERO
@onready var dir : Vector3 
func _ready():
	
	look_at(player)
	dir = global_position.direction_to(player)
	#await get_tree().create_timer(3)
	#queue_free()

func _physics_process(_delta: float) -> void:
	velocity = speed * dir
	
