extends RayCast3D
@onready var VFX = load("res://OrangeEyeBeam.tscn")
#func _physics_process(_delta: float) -> void:
	#if $"..".state == $"..".enemystate.attacking:
		#shoot()
# Called when the node enters the scene tree for the first time.
func shoot(amount):
	enabled = true
	var VFXInstance = VFX.instantiate()
	VFXInstance.global_transform = get_tree().get_first_node_in_group("player").global_transform
	get_tree().root.add_child(VFXInstance)
	for i in amount:
		VFXInstance.global_transform = get_tree().get_first_node_in_group("player").global_transform
		force_raycast_update()
		if is_colliding():
		
			var hit = get_collider()
			if hit != null and hit.is_in_group("player"):
				hit.health -= 0.5 / hit.defense
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
	enabled = false
	if $"..".state == $"..".enemystate.attacking:
		$"..".state = $"..".enemystate.everythingelse
