extends Character

@export var texture : Texture2D
@export_category("Navigation")
@export var target_sector_angle: float = PI
@export var orbit_radius: float = 200

@onready var blood_particles: GPUParticles2D = $BloodParticles

func _ready() -> void:
	super()
	#SignalManager.player_calculate_damage.connect(_on_player_calculate_damage)
	stats.health_changed.connect(_on_health_changed)

	if texture != null:
		sprite.texture = texture

func _on_health_changed(new_health: float) -> void:
	SignalManager.emit_boss_stat_change(stats)
	if new_health == 0:
		SignalManager.emit_boss_died(stats.name)

func recieve_attack(attack_data: AttackData,  direction: Vector2) -> void:
	super(attack_data, direction)
	# blood_particles.rotation = get_angle_to(-direction)
	(blood_particles.process_material as ParticleProcessMaterial).direction = Vector3(-direction.x, -direction.y, 0)
	blood_particles.restart()
