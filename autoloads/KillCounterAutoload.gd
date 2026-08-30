extends Node

signal kill_count_changed(current: int, required: int)
signal kill_requirement_met

var current_kills: int = 0
var required_kills: int = 20

func register_kill() -> void:
	current_kills += 1
	kill_count_changed.emit(current_kills, required_kills)
	
	if current_kills >= required_kills:
		kill_requirement_met.emit()

func reset(new_required: int = 20) -> void:
	current_kills = 0
	required_kills = new_required
	kill_count_changed.emit(current_kills, required_kills)
