extends Area3D

@export var player : Node3D
var damagemult = 1.0
var pos


func _ready() -> void:
	if "player" in get_parent():
		player = get_parent().player
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and player.parrying == true:
		
		body.parried()
		damagemult = player.damagemult
		#if body.health - (eventbus.parrydamage * damagemult) <= 0:
			#eventbus.parrykill.emit()
			#eventbus.grantitem.emit(body.givenfruit)
		#body.health -= (damage * damagemult)
		
		player.health += 5
		if get_parent() != null:
			get_parent().duration.wait_time += 0.1
		if player.health > player.maxhealth:
			player.health = player.maxhealth
		player.punchcooldownnode.stop()
		player.punchcooldownnode.timeout.emit()
		player.parrycooldownnode.stop()
		player.parrycooldownnode.timeout.emit()
func _physics_process(_delta: float) -> void:
	global_position = player.global_position
