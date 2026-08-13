extends Sprite2D

var tween: Tween

func _ready() -> void:
	modulate.a = 0
	%Player.parry_ready.connect(parry_ready)

func parry_ready():
	modulate.a = 1
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_OUT)
