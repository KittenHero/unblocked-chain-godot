extends Node

signal stat_change(stat_name: String, value: float)

func emit_stat_change(stat_name: String, value: float) -> void:
	stat_change.emit(stat_name, value)
	return
