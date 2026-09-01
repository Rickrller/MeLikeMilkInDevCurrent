extends Node
class_name State
var used : bool = false
@onready var fruitmesh = %fruitmodel
@onready var anims = $"../../Anims/R_AnimationTree"["parameters/playback"]
@onready var animnode = $"../../Anims/R_AnimationTree"
@onready var rightarm = $"../../Neck/CameraBobber/rightarm/metarig/Skeleton3D/Cube_001"

func Enter():
	pass
	
func Update(_delta: float):
	pass
	
func Exit():
	pass
	
func Physics_Update(_delta: float):
	pass
	
