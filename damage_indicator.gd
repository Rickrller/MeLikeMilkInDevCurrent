extends Sprite2D
@onready var player = get_parent()
var last_health: float
var damage_tween: Tween

func _ready():
	modulate.a = 0
	last_health = player.health

func _process(_delta):
	if player.health < last_health:
		var amount_lost = last_health - player.health
		if damage_tween:
			damage_tween.kill()
		modulate.a = amount_lost / 20
		damage_tween = create_tween()
		damage_tween.tween_property(self, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_OUT)
	last_health = player.health
