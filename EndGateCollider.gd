extends Node3D

@onready var collision_shape: CollisionShape3D = $"."

func _ready() -> void:
	KillCounter.kill_requirement_met.connect(_on_requirement_met)

func _on_requirement_met() -> void:
	collision_shape.disabled = true
