extends Area3D
@export var damage : float = 50
var damagemult
@onready var FX = $FX
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(FX)
	get_tree().current_scene.add_child(FX)
	if not damagemult:
		damagemult = 1
	await get_tree().create_timer(0.3).timeout
	call_deferred("queue_free")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.parried()
		body.health -= damage * damagemult
