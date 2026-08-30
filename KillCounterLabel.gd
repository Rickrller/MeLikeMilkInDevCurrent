# KillCounterLabel.gd
extends Label

func _ready() -> void:
	KillCounter.kill_count_changed.connect(_on_kill_count_changed)
	_on_kill_count_changed(KillCounter.current_kills, KillCounter.required_kills)

func _on_kill_count_changed(current: int, required: int) -> void:
	text = "%d/%d kills" % [current, required]
