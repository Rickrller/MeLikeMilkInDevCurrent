extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	$ButtonPressed.playing = true
	get_tree().change_scene_to_file("res://Tutorial.tscn")

func _on_mouse_entered() -> void:
	$ButtonClick.playing = true
