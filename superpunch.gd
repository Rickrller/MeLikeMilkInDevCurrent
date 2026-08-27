extends Area3D
@export var damage : float = 50
var damagemult
@onready var FX = $FX
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	if not damagemult:
		damagemult = 1
	await get_tree().create_timer(0.3).timeout
	#remove_child(FX)
	#get_tree().current_scene.add_child(FX)
	for child in get_children():
		print(child)
	call_deferred("queue_free")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.parried()
		body.health -= damage * damagemult
