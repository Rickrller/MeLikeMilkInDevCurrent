extends Node
@export var protien : float = 100 #attack
@export var minerals : float = 100 #defense
@export var vitamins : float = 100 #stamina
@export var carbs : float = 100 #movement speed
@export var hydration : float = 100 #regen
var max_value = 125.0
@onready var player = $".."
@onready var effects = $"../effects"
func _ready() -> void:
	$tick.start()

func _on_tick() -> void:
	protien -= 1
	minerals -= 1
	carbs -= 1
	vitamins -= 1
	hydration -= 1

func _process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 6 == 0:
		#player.defense = player.basedefense * minerals #minerals is defensemult
		#player.damagemult = protien
		#player.speedmult = carbs
		#player.stamina = vitamins
		#player.regen = hydration
		if protien > max_value:
			protien = max_value
		if  carbs > max_value:
			carbs = max_value
		if vitamins > max_value:
			vitamins = max_value 
		if hydration > max_value:
			hydration = max_value
		if minerals > max_value:
			minerals = max_value
		$"../Panel/Control/protien".value = protien
		$"../Panel/Control/hydration".value = hydration
		$"../Panel/Control/vitamins".value = vitamins
		$"../Panel/Control/carbs".value = carbs
		$"../Panel/Control/minerals".value = minerals
		if fmod(protien, 1) == 0:
			effects.applyweakness(int(protien) / 25.0)
		if fmod(carbs, 1) == 0:
			effects.applyslowness(int(carbs) / 25.0)
		if fmod(protien, 1) == 0:
			effects.applyfragility(int(minerals) / 25.0)
		if fmod(vitamins, 1) == 0:
			effects.applyfatigue(int(vitamins) / 25.0)
		#if protien < 0.01 or carbs < 0.01 or hydration < 0.01 or minerals < 0.01 or vitamins < 0.01:
			#get_tree().quit()
			#^^^ kills player if no nutrients
