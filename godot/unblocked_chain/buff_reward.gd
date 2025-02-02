extends UnblockChainReward
class_name BuffReward

@export var buff : StatusCondition

func apply(character: Character) -> void:
	var b : StatusCondition = buff.duplicate()
	b.duration *= multiplier
	b.apply(character)
