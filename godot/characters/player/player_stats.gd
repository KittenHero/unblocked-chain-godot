extends Stats
class_name PlayerStats

signal stamina_changed(new_stamina: int)

@export var stamina: float 
@export var max_stamina: float
@export var parry_stamina_cost: float

func change_stamina(delta: float) -> void:
	stamina = clamp(stamina + delta, 0, max_stamina)
	stamina_changed.emit(stamina)
