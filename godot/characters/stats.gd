extends Resource

class_name PlayerStats 

@export var id: int
@export var health: float
@export var stamina: float 
@export var parry_stamina_cost: float

func modify_stat(stat_name: String, value: float) -> void:
	assert(get(stat_name) != null)
	self.set(stat_name, value)
	
