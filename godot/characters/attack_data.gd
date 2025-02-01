extends Resource

class_name AttackData

@export var name: String
@export var damage: float
@export_range(0, 99, 1, "Max resistance is 100") var knockback: float
@export_range(0, 99, 1, "Max resistance is 100") var interrupt_strength: float
## Attacker hit stop received value
@export var attack_hitstop_frames: int
## Victim hit stop received value
@export var victim_hitstop_frames: int
@export var effects: Dictionary
