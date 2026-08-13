extends Sprite2D

func _input(event):
	if event.is_action_pressed("parry"):
		if %Player.parrycooldown == false:
			modulate.a = 1
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_OUT)
