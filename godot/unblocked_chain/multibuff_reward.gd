extends UnblockChainReward
class_name MultiBuffReward

@export var buffs : Array[StatusCondition]
@export var duration : float = 10.0

func apply(character: Character) -> void:
	for b : StatusCondition in buffs:
		var buff : StatusCondition = b.duplicate()
		buff.duration = duration * multiplier
		buff.apply(character)
