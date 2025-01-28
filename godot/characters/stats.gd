extends Resource

class_name Stats 

signal health_changed(new_health: int)
signal died()

@export var id: int
@export var name: WorldData.Characters
@export var health: float
@export var max_health: float
@export var crit_rate: float = 0.05
@export var crit_damage: float = 1.5
@export var defense: float = 0.0

func modify_stat(stat_name: String, value: float) -> void:
	assert(get(stat_name) != null)
	self.set(stat_name, value)

func change_health(delta: float) -> void:
	health = clamp(health + delta, 0, max_health)
	health_changed.emit(health)
	if health == 0:
		died.emit()

func calculate_mitigated_damage(damage: float) -> float:
	return max(damage - defense, 1)
