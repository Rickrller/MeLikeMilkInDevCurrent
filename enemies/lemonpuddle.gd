extends Area3D
@export var target_type : String
@export var targets : Array[Node3D] = []
@onready var tick = $dmgtick
const damage = 0.4
@onready var VFX = load("res://LemonPuddleVfx.tscn")
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		global_position = player.global_position
	tick.start()
	var VFXInstance = VFX.instantiate()
	VFXInstance.global_transform = global_transform
	get_tree().root.add_child.call_deferred(VFXInstance)
	await get_tree().create_timer(5).timeout
	queue_free()
func _on_dmgtick() -> void:
	for target in targets:
		if target.is_in_group(target_type) and not target.is_in_group("fallentree"):
			target.health -= damage
	tick.start()


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group(target_type) and not body.is_in_group("fallentree"):
		targets.erase(body)
		body.speed *= 2.5
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(target_type) and not body.is_in_group("fallentree"):
		targets.append(body)
		body.speed /= 2.5
