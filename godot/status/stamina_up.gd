extends StatusCondition
class_name StaminaUp

@export var stamina_regen_multiplier := 8.0

func apply(character: Character) -> void:
	super(character)
	(character as PlayerCharacter).player_stats.stamina_regen *= stamina_regen_multiplier

func unapply(character: Character) -> void:
	super(character)
	(character as PlayerCharacter).player_stats.stamina_regen /= stamina_regen_multiplier
