extends Stats
class_name PlayerStats

signal stamina_changed(new_stamina: int)

@export var stamina: float 
@export var max_stamina: float
@export var parry_stamina_cost: float
@export var stamina_regen: float = 0.1
@export var crit_rate: float = 0.5
@export var crit_damage: float = 1.5

func change_stamina(delta: float) -> void:
	var value := clampf(stamina + delta, 0, max_stamina)
	if value != stamina:
		stamina = value
		stamina_changed.emit(stamina)
