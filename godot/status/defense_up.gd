extends StatusCondition
class_name DefenseUp

@export var defense_up := 20

func apply(character: Character) -> void:
	super(character)
	character.stats.defense += defense_up

func unapply(character: Character) -> void:
	super(character)
	character.stats.defense -= defense_up
