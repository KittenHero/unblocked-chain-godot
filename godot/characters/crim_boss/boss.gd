extends Character
class_name Boss

@onready var agent : NavigationAgent2D = $Agent
@onready var blood_particles: GPUParticles2D = $BloodParticles

func _ready() -> void:
	super()
	stats.health_changed.connect(_on_health_changed)

func _on_health_changed(_delta: float) -> void:
	SignalManager.emit_boss_stat_change(stats)

func recieve_attack(attack_data: AttackData,  direction: Vector2) -> void:
	super(attack_data, direction)
	blood_particles.rotation = get_angle_to(-direction)
	blood_particles.restart()
