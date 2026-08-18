extends Node
@onready var nutrients = $"../nutrition"
@onready var player = $".."
@export var weakness : int
@export var thirst : int
@export var fragility : int
@export var slowness : int
@export var fatigue : int

func applyweakness(tier):

	weakness = tier
	if weakness == 4:
		player.damagemult = 0.95
	elif weakness == 3:
		player.damagemult = 0.85
	elif weakness == 2:
		player.damagemult = 0.7
	elif weakness == 1:
		player.damagemult = 0.5
	else:
		return

func applyslowness(tier):
	slowness = tier
	if tier == 4:
		player.speedmult = 0.95
	elif tier == 3:
		player.speedmult = 0.85
	elif tier == 2:
		player.speedmult = 0.7
	elif tier == 1:
		player.speedmult = 0.5
	else:
		return

func applyfragility(tier):
	if tier == 4:
		player.defensemult = 0.95
	elif tier == 3:
		player.defensemult = 0.85 
	elif tier == 2:
		player.defensemult = 0.7
	elif tier == 1: 
		player.defensemult = 0.5 
	else:
		return

func applyfatigue(tier):
	if tier == 4:
		player.stamina = 0.95
	elif tier == 3:
		player.stamina = 0.85
	elif tier == 2:
		player.stamina = 0.7
	elif tier == 1:
		player.stamina = 0.5
	else:
		return

func _process(_delta: float) -> void:
	player.defense = player.basedefense * player.defensemult
