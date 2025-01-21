extends Resource

class_name Stats 

signal health_changed(new_health: int)

@export var id: int
@export var health: float
@export var max_health: float

func modify_stat(stat_name: String, value: float) -> void:
	assert(get(stat_name) != null)
	self.set(stat_name, value)

func change_health(delta: float) -> void:
	health = clamp(health + delta, 0, max_health)
	health_changed.emit(health)
