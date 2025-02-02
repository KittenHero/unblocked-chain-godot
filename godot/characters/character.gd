extends CharacterBody2D
class_name Character

@onready var states := %States
@onready var input_controller: InputController = %InputController
@onready var facing: Marker2D = %Facing
@onready var animation : AnimationPlayer = %AnimationPlayer
@onready var sprite : Sprite2D = %Sprite2D

@export var current_state: CharacterState
@export var animation_state := AnimationState.States.Neutral
@export_category("Movement")
@export var speed : float = 200.0
@export var time_to_max : float = .3
@export var deceleration : float = 175.0
@export_category("Resources")
@export var stats : Stats 

var active_conditions : Dictionary = {}
var local_time_scale := 1.0

var is_launched: bool = false
var is_flinching: bool = false


func _ready() -> void:
	assert(stats != null, "Attach your stats sheet")
	
	facing.set_as_top_level(true)
	if current_state == null:
		current_state = states.get_child(0)
	current_state.enter(self)
	
func _physics_process(delta: float) -> void:
	facing.global_position = global_position
	var aim := input_controller.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down")
	if aim != Vector2.ZERO:
		facing.rotation = Vector2.ZERO.angle_to_point(aim)
	delta *= local_time_scale
	current_state.update(delta, self, input_controller)
	move_and_slide()

func _process(_delta: float) -> void:
	if animation_state == AnimationState.States.Busy: return
	input_controller.consume()
	# prioritises states lower in the list (e.g, melee2 > move)
	for s: CharacterState in states.get_children().slice(-1 , -1-states.get_child_count(), -1):
		if s.can_transition(current_state, self, input_controller):
			current_state.exit(self)
			s.enter(self)
			current_state = s
			break

func _input(event: InputEvent) -> void:
	input_controller.handle(event)
 
func update_sprite_direction(direction: Vector2) -> void:
	if direction.x < 0:
		scale.y = -1
		rotation = PI
	elif direction.x > 0:
		scale.y = 1
		rotation = 0

# Movement
func move(delta: float,  input: InputController) -> void:
	var target_velocity := speed * input.get_vector(
		&"move_left", &"move_right",
		&"move_up", &"move_down",
	).normalized()
	velocity += (target_velocity - velocity).limit_length(speed * delta / time_to_max)
	if not is_launched:
		update_sprite_direction(velocity)

func knockback(knockback_velocity: Vector2) -> void:
	velocity = knockback_velocity
	facing.rotation = -knockback_velocity.angle() 
	update_sprite_direction(-velocity)

func manual_move(move_speed: float) -> void:
	if is_launched: return
	velocity = move_speed * Vector2.RIGHT.rotated(facing.rotation)
	update_sprite_direction(velocity)

func slow_down(delta: float) -> void:
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)
		
# Combat		
func attack(target: Node2D, attack_node: NodePath) -> void:
	var valid := target.has_method("recieve_attack")
	if not valid:
		assert(valid, "Unexpected collision fix now")
	
	var attack_data : AttackData = (get_node(attack_node) as Attack).attack_data.duplicate()
	var is_crit : bool = randf() < stats.crit_rate
	if is_crit:
		attack_data.damage = attack_data.damage * stats.crit_damage
		attack_data.effects = {"is_crit": true}
		
	# print(self.name, " attacked ", target.name, " for ", attack_data.damage, " HP")
	# TODO: modify attack data hit direction based on sprite orientation or facing
	var hit_direction : Vector2 = ((target as CharacterBody2D).global_position - global_position).normalized()
	@warning_ignore("unsafe_method_access")
	target.recieve_attack(attack_data, hit_direction)
	CombatManager.synchronize_hitstop(attack_data, [self, target])
	
func recieve_attack(attack_data: AttackData,  direction: Vector2) -> void:
	if stats.health == 0:
		return
	var damage : float = stats.calculate_mitigated_damage(attack_data.damage)
	stats.change_health(-damage)

	# launched > flinch
	if attack_data.knockback > current_state.interrupt_resistance:
		is_launched = true
	elif attack_data.interrupt_strength > current_state.interrupt_resistance:
		is_flinching = true
		
	knockback(direction*attack_data.knockback)

func start_hitstop() -> void:
	set_physics_process(false)
	# This already disables animation player
	# Also activates RESET track, consider usage
	set_process(false)
	animation.pause()
	
func end_hitstop() -> void:
	set_physics_process(true)
	set_process(true)
	animation.play()

func reset_damaged_state() -> void:
	is_flinching = false
	is_launched = false

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
		#var minion_controller: EnemyController = input_controller
		#LiveDebug.update_group({
			#"minion": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
			#"minion_input": "{0} {1}".format([minion_controller.current_action, minion_controller.current_state]),
			#"minion_move": str(minion_controller.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")),
			#"minion_aim": str(minion_controller.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down"))
		#})
	#if self.is_in_group("boss"):
		#var minion_controller: EnemyController = input_controller
		#LiveDebug.update_group({
			#"minion": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
			#"minion_input": "{0} {1}".format([minion_controller.current_action, minion_controller.current_state]),
			#"minion_move": str(minion_controller.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")),
			#"minion_aim": str(minion_controller.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down"))
		#})
