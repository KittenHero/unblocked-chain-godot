extends Character
class_name PlayerCharacter

@export var player_stats: PlayerStats
@export var miner : UnblockChainMiner

func _ready() -> void:
	player_stats.stamina_changed.connect(_on_stamina_changed)
	player_stats.health_changed.connect(_on_health_changed)
	# TODO: this should connect to combo counter instead
	miner.mined.connect(self._recieve_reward)
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	if current_state.name != "Dead":
		change_stamina(player_stats.stamina_regen * delta * player_stats.max_stamina)
		miner.mine(delta)
	if OS.is_debug_build(): update_debug()

# Stats
func change_stamina(value: float) -> void:
	player_stats.change_stamina(value)

func change_health(value: float) -> void:
	player_stats.change_health(value)

# Updates
func _on_stamina_changed(new_stamina: float) -> void:
	SignalManager.emit_player_stat_change('stamina', new_stamina)

func _on_health_changed(new_health: float) -> void:
	SignalManager.emit_player_stat_change('health', new_health)

func attack(target: Node2D, attack_node: NodePath) -> void:
	super(target, attack_node)
	$sfx.stream = preload("res://sfx/hit_2.wav")
	$sfx.play()
	if miner != null:
		# TODO: duration based on attack
		var duration : float = 0.5
		miner.overclock(duration)

func _recieve_reward(reward: UnblockChainReward) -> void:
	await get_tree().create_timer(miner.cooldown).timeout
	reward.apply(self)

func update_debug() -> void:
	if current_state.name == "Dead": return
	# var buffered: BufferedCharacterController = input_controller
	#LiveDebug.update_group({
		#"FPS": str(Engine.get_frames_per_second()),
		#"anim": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
		##"velocity":  str(velocity),
		##"active_input": JSON.stringify(buffered.pressing.keys()),
		##"input_buffer": str(buffered.buffer.map(func (event: TimedInput) -> String: return "1" if event.event.is_pressed() else "0")),
	#})
