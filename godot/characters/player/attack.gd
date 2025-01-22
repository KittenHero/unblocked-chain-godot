extends Area2D

class_name Attack

@export var attack_data : AttackData

func _ready() -> void:
	assert(attack_data != null)
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("players"):
		SignalManager.emit_player_land_attack(body, attack_data)
