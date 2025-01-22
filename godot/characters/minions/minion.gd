extends Character

@export var texture : Texture2D
@export_category("Navigation")
@export var target_sector_angle: float = PI
@export var orbit_radius: float = 200

func _ready() -> void:
	super()
	SignalManager.player_calculate_damage.connect(_on_player_calculate_damage)
	if texture != null:
		sprite.texture = texture

func _on_player_calculate_damage(target: Node, direction: Vector2, attack_data: AttackData) -> void:
	print("Taking damage of value {0}".format([attack_data.damage]))
	knockback(direction*attack_data.knockback)
	knockback_timer = attack_data.knockback_timer
	pass
	
