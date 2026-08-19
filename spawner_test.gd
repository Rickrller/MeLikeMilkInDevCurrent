extends Node3D

const apple = preload("res://enemies/apple.tscn")
const aloe = preload("res://enemies/aloevera.tscn") 
const coconut = preload("res://enemies/coconut.tscn")
const strawberry = preload("res://enemies/strawberry.tscn")
const starfruit = preload("res://enemies/starfruit.tscn")
const pearto = preload("res://enemies/pearto.tscn") 
const orange = preload("res://enemies/orange.tscn")
const lemon = preload("res://enemies/lemon.tscn") 
const grapes = preload("res://enemies/grapes.tscn")
const durian = preload("res://enemies/durian.tscn") 

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	spawn_enemy(lemon, 1, 0)
	spawn_enemy(pearto, 10, 0)

func spawn_enemy(enemy_type, enemy_amount, delay) -> void:
	var spawnshape = $SpawnArea/SpawnAreaShape
	var spawnshapesize = spawnshape.shape.size
	for loops in enemy_amount:
		var random_x = randf_range(-spawnshapesize.x / 2, spawnshapesize.x / 2)
		var random_z = randf_range(-spawnshapesize.z / 2, spawnshapesize.z / 2)
		var random_y = randf_range(-spawnshapesize.y / 2, spawnshapesize.y / 2)
		var enemy_instance = enemy_type.instantiate()
		enemy_instance.position = position + Vector3(random_x, random_y, random_z)
		get_tree().current_scene.add_child(enemy_instance)
		await get_tree().create_timer(delay).timeout
