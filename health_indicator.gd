extends Sprite2D

func _process(_delta: float) -> void:
	if Engine.get_frames_drawn() % 2 == 0:
		modulate.a = 1 - %Player.health / 100
