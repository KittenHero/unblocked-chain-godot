extends Node

# Stats
signal stat_change(stat_name: String, value: float)
signal player_stat_change(stat_name: String, value: float)
signal boss_stat_change(stats: Stats)
signal player_died()
signal boss_died(boss_name: WorldData.Characters)

func emit_stat_change(stat_name: String, value: float) -> void:
	stat_change.emit(stat_name, value)

func emit_player_stat_change(stat_name: String, value: float) -> void:
	player_stat_change.emit(stat_name, value)
	
func emit_boss_stat_change(stats: Stats) -> void:
	boss_stat_change.emit(stats)

func emit_player_died() -> void:
	player_died.emit()

func emit_boss_died(boss_name: WorldData.Characters) -> void:
	boss_died.emit(boss_name)
