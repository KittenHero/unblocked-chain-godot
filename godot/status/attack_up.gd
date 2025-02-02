extends StatusCondition
class_name AttackUp

@export var crit_rate_mult := 100.0
@export var crit_dmg_mult := 2.0

func apply(character: Character) -> void:
	super(character)
	character.stats.crit_rate *= crit_rate_mult
	character.stats.crit_damage *= crit_dmg_mult

func unapply(character: Character) -> void:
	super(character)
	character.stats.crit_rate /= crit_rate_mult
	character.stats.crit_damage /= crit_dmg_mult
