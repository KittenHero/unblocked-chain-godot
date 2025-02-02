extends StatusCondition
class_name SpeedUp

@export var speed_mult := 1.5

func apply(character: Character) -> void:
	super(character)
	character.animation.speed_scale *= speed_mult
	character.speed *= speed_mult
	character.local_time_scale *= speed_mult

func unapply(character: Character) -> void:
	super(character)
	character.animation.speed_scale /= speed_mult
	character.speed /= speed_mult
	character.local_time_scale /= speed_mult
