extends Sprite2D

#var tween: Tween
#
#func _ready() -> void:
	#modulate.a = 0
	#get_parent().parry_cast.connect(parry_cast)
#
#func parry_cast():
	#modulate.a = 0.5
	#tween = create_tween()
	#tween.tween_property(self, "modulate:a", 0.0, 1).set_ease(Tween.EASE_OUT)
