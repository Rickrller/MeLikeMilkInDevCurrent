extends RayCast3D

#func _physics_process(_delta: float) -> void:
	#if $"..".state == $"..".enemystate.attacking:
		#shoot()
# Called when the node enters the scene tree for the first time.
func shoot(amount):
	enabled = true
	for i in amount:
		
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
