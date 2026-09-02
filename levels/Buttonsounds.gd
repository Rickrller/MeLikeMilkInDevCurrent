extends Button

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)

func _on_pressed() -> void:
	$ButtonPressed.playing = true

func _on_mouse_entered() -> void:
	$ButtonClick.playing = true
