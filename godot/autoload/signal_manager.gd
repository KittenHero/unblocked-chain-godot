extends Node

# Stats
signal stat_change(stat_name: String, value: float)
signal player_stat_change(stat_name: String, value: float)
signal boss_stat_change(stat_name: String, value: float)

func emit_stat_change(stat_name: String, value: float) -> void:
	stat_change.emit(stat_name, value)

func emit_player_stat_change(stat_name: String, value: float) -> void:
	player_stat_change.emit(stat_name, value)
	
func emit_boss_stat_change(stat_name: String, value: float) -> void:
	boss_stat_change.emit(stat_name, value)
