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
@export var stats: PlayerStats

func _ready() -> void:
	facing.set_as_top_level(true)
	if current_state == null:
		current_state = states.get_child(0)
	current_state.enter(self)

func _physics_process(delta: float) -> void:
	current_state.update(delta, self, input_controller)
	move_and_slide()
	facing.global_position = global_position
	if OS.is_debug_build(): update_debug()

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
	# TODO: validate player on kb&m vs controller
	if event is InputEventMouse:
		facing.look_at(get_global_mouse_position())

func update_sprite_direction(direction: Vector2):
	if direction.x < 0:
		scale.y = -1
		rotation = PI
	elif direction.x > 0:
		scale.y = 1
		rotation = 0

func move(delta: float,  input: InputController) -> void:
	var target_velocity := speed * input.get_dual_axis(
		&"move_left", &"move_right",
		&"move_up", &"move_down",
	).normalized()
	velocity += (target_velocity - velocity).limit_length(speed * delta / time_to_max)
	update_sprite_direction(velocity)

func manual_move(move_speed: float) -> void:
	velocity = move_speed * Vector2.RIGHT.rotated(facing.rotation)
	update_sprite_direction(velocity)


func slow_down(delta: float) -> void:
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)

# Stats
func can_parry() -> bool:
	return stats.stamina > stats.parry_stamina_cost

func increase_stamina(value: float) -> void:
	stats.stamina += value

func decrease_stamina(value: float) -> void:
	stats.stamina -= value

func update_debug() -> void:
	var buffered: BufferedCharacterController = input_controller
	LiveDebug.update_group({
		"FPS": str(Engine.get_frames_per_second()),
		"anim": "{0} {1}".format([current_state.name, AnimationState.States.find_key(animation_state)]),
		#"velocity":  str(velocity),
		"active_input": JSON.stringify(buffered.pressing.keys()),
		#"input_buffer": str(buffered.buffer.map(func (event: TimedInput) -> String: return "1" if event.event.is_pressed() else "0")),
	})
