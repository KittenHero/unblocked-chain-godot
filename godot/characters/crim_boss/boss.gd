extends Character
class_name Boss

@onready var agent : NavigationAgent2D = $Agent
@onready var blood_particles: GPUParticles2D = $BloodParticles
@onready var punch_collision: CollisionShape2D = $BigPunch/CollisionShape2D
func _ready() -> void:
	super()
	stats.health_changed.connect(_on_health_changed)


func _on_health_changed(new_health: float) -> void:
	SignalManager.emit_boss_stat_change(stats)
	if new_health == 0:
		SignalManager.emit_boss_died(stats.name)


func _physics_process(delta: float) -> void:
	super(delta)
	if OS.is_debug_build(): update_debug()

func recieve_attack(attack_data: AttackData,  direction: Vector2) -> void:
	super(attack_data, direction)
	blood_particles.rotation = get_angle_to(-direction)
	blood_particles.restart()

func attack(target: Node2D, attack_node: NodePath) -> void:
	#var attack_data : AttackData = (get_node(attack_node) as Attack).attack_data
	# Only 1 strike taken
	#if attack_data.name.contains("Punch"):
		#call_deferred("punch_collision.disabled", true)
	super(target, attack_node)

func update_debug() -> void:
	if self.is_in_group("boss"):
		var minion_controller: EnemyController = input_controller
		LiveDebug.update_group({
			"minion": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
			"minion_input": "{0} {1}".format([minion_controller.current_action, minion_controller.current_state]),
			"minion_move": str(minion_controller.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")),
			"minion_aim": str(minion_controller.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down"))
		})
