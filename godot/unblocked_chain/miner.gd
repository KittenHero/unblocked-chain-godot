extends Node
class_name UnblockChainMiner

## number of required compute (FLOPS)
@export var proof_of_work : float = 150.0
var current_compute : float = 0.0
@export var base_compute : float = 2.0 # FLOPS
@export var overclock_boost : float = 4 # multiplier
var overclock_duration := 0.0
@export var cooldown := 5.0
var cooldown_timer := 0.0
@export var rewarder : UnblockChainRewarder

signal mined(reward: UnblockChainReward);

func _physics_process(delta: float) -> void:
	mine(delta)

func overclock(duration: float) -> void:
	overclock_duration += duration

func mine(delta: float) -> void:
	if cooldown_timer >= 0:
		cooldown_timer -= delta
		return

	var compute_delta := delta * base_compute
	var overclock_delta := minf(overclock_duration, delta)
	overclock_duration -= overclock_delta

	var overclock_compute:= base_compute * overclock_delta * (overclock_boost - 1.0)
	current_compute += compute_delta + overclock_compute

	if current_compute >= proof_of_work:
		cooldown_timer = cooldown
		current_compute -= proof_of_work
		mined.emit(rewarder.request_reward())
