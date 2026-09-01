extends Button

func _on_pressed() -> void:
	$ButtonPressed.playing = true
	get_tree().change_scene_to_file("res://TownMap.tscn")

func _on_mouse_entered() -> void:
	$ButtonClick.playing = true
