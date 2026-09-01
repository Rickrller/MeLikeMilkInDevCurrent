extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	get_tree().quit()

func _on_mouse_entered() -> void:
	$ButtonClick.playing = true
