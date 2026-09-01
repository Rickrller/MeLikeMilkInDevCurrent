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
const grapebomb = preload("res://clustergrape.tscn")
const carrot = preload("res://enemies/carrot.tscn")

@export var applespawns : int
@export var aloespawns : int
@export var coconutspawns : int
@export var strawberryspawns : int
@export var starfruitspawns : int
@export var peartospawns : int
@export var orangespawns : int
@export var lemonspawns : int
@export var grapesspawns : int
@export var durianspawns : int
@export var grapebombspawns : int
@export var carrotspawns : int
func _ready() -> void:
	await get_tree().create_timer(2.0).timeout

func spawn_enemy(enemy_type, enemy_amount, delay) -> void:
	var spawnshape = $SpawnAreaShape
	var spawnshapesize = spawnshape.shape.size
	for loops in enemy_amount:
		var random_x = randf_range(-spawnshapesize.x / 2, spawnshapesize.x / 2)
		var random_y = randf_range(-spawnshapesize.y / 2, spawnshapesize.y / 2)
		var random_z = randf_range(-spawnshapesize.z / 2, spawnshapesize.z / 2)
		var enemy_instance = enemy_type.instantiate()
		get_tree().current_scene.add_child(enemy_instance)
		enemy_instance.global_position = spawnshape.to_global(Vector3(random_x, random_y, random_z))
		await get_tree().create_timer(delay).timeout


func _on_spawn_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		spawn_enemy(coconut, coconutspawns, 0)
		spawn_enemy(strawberry, strawberryspawns, 0)
		spawn_enemy(grapes, grapesspawns, 0)
		spawn_enemy(starfruit, starfruitspawns, 0)
		spawn_enemy(durian, durianspawns, 0)
		spawn_enemy(lemon, lemonspawns, 0)
		spawn_enemy(orange, orangespawns, 0)
		spawn_enemy(aloe, aloespawns, 0)
		spawn_enemy(apple, applespawns, 0)
		spawn_enemy(carrot, carrotspawns, 0)
		spawn_enemy(pearto, peartospawns, 0)
