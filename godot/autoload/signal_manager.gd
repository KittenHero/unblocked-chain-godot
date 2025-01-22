extends Node

# Stats
signal stat_change(stat_name: String, value: float)
signal player_stat_change(stat_name: String, value: float)
signal boss_stat_change(stat_name: String, value: float)
# Combat
signal player_land_attack(target: Node, attack_data: AttackData)
signal player_calculate_damage(target: Node, direction: Vector2, attack_data: AttackData)
signal enemy_land_attack(target: Node, attack_data: AttackData)
signal enemy_calculate_damage(target: Node, direction: Vector2, attack_data: AttackData)

func emit_stat_change(stat_name: String, value: float) -> void:
	stat_change.emit(stat_name, value)

func emit_player_stat_change(stat_name: String, value: float) -> void:
	player_stat_change.emit(stat_name, value)
	
func emit_boss_stat_change(stat_name: String, value: float) -> void:
	boss_stat_change.emit(stat_name, value)
	
# Combat
func emit_player_land_attack(target: Node, attack_data: AttackData) -> void:
	player_land_attack.emit(target, attack_data)

func emit_player_calculate_damage(target: Node, direction: Vector2, attack_data: AttackData) -> void:
	player_calculate_damage.emit(target, direction, attack_data)

func emit_enemy_land_attack(target: Node, attack_data: AttackData) -> void:
	enemy_land_attack.emit(target, attack_data)

func emit_enemy_calculate_damage(target: Node, direction: Vector2, attack_data: AttackData) -> void:
	enemy_calculate_damage.emit(target, direction, attack_data)


	
