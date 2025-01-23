extends Character
class_name PlayerCharacter

@export var player_stats: PlayerStats

func _ready() -> void:
	player_stats.health_changed.connect(_on_health_changed)
	player_stats.stamina_changed.connect(_on_stamina_changed)
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	player_stats.change_stamina(player_stats.stamina_regen * delta * player_stats.max_stamina)

# Stats
func can_parry() -> bool:
	return player_stats.stamina > player_stats.parry_stamina_cost

func change_stamina(value: float) -> void:
	player_stats.change_stamina(value)

func change_health(value: float) -> void:
	player_stats.change_health(value)

# Updates
func _on_stamina_changed(new_stamina: float) -> void:
	SignalManager.emit_player_stat_change('stamina', new_stamina)

func _on_health_changed(new_health: float) -> void:
	SignalManager.emit_player_stat_change('health', new_health)

# Decorate - ?? are you making cake?
# TODO: move to character.gd (depend on character stats not player stats?)
func attack(target: Node2D, attack_node: NodePath) -> void:
	var collision_valid : bool = target.has_method("recieve_attack")
	if not collision_valid:
		assert(collision_valid, "Unexpected collision fix now")

	var attack_data := (get_node(attack_node) as Attack).attack_data.duplicate()
	var is_crit : bool = randf() < player_stats.crit_rate
	if is_crit:
		attack_data.damage = attack_data.damage * player_stats.crit_damage
		attack_data.effects = {"is_crit": true}
	# TODO: modify attack data hit direction based on sprite orientation or facing
	var hit_direction : Vector2 = ((target as CharacterBody2D).global_position - global_position).normalized()
	target.recieve_attack(attack_data, hit_direction)


func update_debug() -> void:
	pass
	#if self.is_in_group("players"):
		#var buffered: BufferedCharacterController = input_controller
		#LiveDebug.update_group({
			#"FPS": str(Engine.get_frames_per_second()),
			#"anim": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
			##"velocity":  str(velocity),
			#"active_input": JSON.stringify(buffered.pressing.keys()),
			##"input_buffer": str(buffered.buffer.map(func (event: TimedInput) -> String: return "1" if event.event.is_pressed() else "0")),
		#})
	#if self.is_in_group("minions"):
		#var minion_controller: MinionController = input_controller
		#LiveDebug.update_group({
			#"minion": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
			#"minion_input": "{0} {1}".format([minion_controller.current_action, minion_controller.current_state]),
			#"minion_move": str(minion_controller.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")),
			#"minion_aim": str(minion_controller.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down"))
		#})
