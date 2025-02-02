extends Node
class_name UnblockChainRewarder

@export var rewards : Array[UnblockChainReward]
@export var rarity_weights : Dictionary = {
	UnblockChainReward.Rarity.Common: 0.6,
	UnblockChainReward.Rarity.Uncommon: 0.3,
	UnblockChainReward.Rarity.Rare: 0.1,
}
@export var rarity_guarantee : Dictionary = {
	UnblockChainReward.Rarity.Uncommon: 3,
	UnblockChainReward.Rarity.Rare: 8,
}
var guarantee_counter: Dictionary = {
	UnblockChainReward.Rarity.Uncommon: 0,
	UnblockChainReward.Rarity.Rare: 0,
}

func filter_rewards(rarity: UnblockChainReward.Rarity) -> Array[UnblockChainReward]:
	return rewards.filter(
		func (r: UnblockChainReward) -> bool:
			return r.rarity == rarity
	)

func request_reward() -> UnblockChainReward:
	## base reward
	var p := randf()
	var cum : float = 0.0
	var rarity := UnblockChainReward.Rarity.Common
	for r : UnblockChainReward.Rarity in rarity_weights.keys():
		var w : float = rarity_weights[r]
		if cum < p and p < cum + w:
			rarity = r
			break
		cum += w
	# guarantee
	for r : UnblockChainReward.Rarity in guarantee_counter.keys():
		var counter: int = guarantee_counter[r] + 1
		if r <= rarity:
			counter = 0
		elif counter == rarity_guarantee[r]:
			counter = 0
			rarity = r
		guarantee_counter[r] = counter
	return filter_rewards(rarity).pick_random()
