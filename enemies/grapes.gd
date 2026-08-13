extends CharacterBody3D


@export var speed : float
@onready var player : Node3D = %Player
@export var health : float
@onready var grapeprojectile = preload("res://enemies/grape.tscn")
@export var fruitgiven : String = "grapes"

func _ready():
	$Timer.start()
	
	
func shoot():
	var instance = grapeprojectile.instantiate()
	get_tree().current_scene.add_child(instance)
	
	instance.global_position = global_position
	instance.player = player.global_position
	
func parried():
	queue_free()


func _on_timer_timeout() -> void:
	shoot()
