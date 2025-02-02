extends Resource
class_name UnblockChainReward

enum Rarity {
	Common = 0,
	Uncommon = 1,
	Rare = 2,
}

@export var icon : Texture2D
@export var name : String
@export var rarity : Rarity
var multiplier : float = 1.0

func apply(_character: Character) -> void:
	pass
