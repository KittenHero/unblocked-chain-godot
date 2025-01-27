extends CharacterState

@export var gravity: float = 10.0
@export var damping_factor: float = 0.95 

var initial_velocity: Vector2 = Vector2.ZERO
var current_velocity: Vector2 = Vector2.ZERO
var launch_duration: float = 0.0
var launch_elapsed: float = 0.0

func enter(character: Character) -> void:
	self.initial_velocity = character.velocity
	self.current_velocity = character.velocity
	launch_duration = (2 * initial_velocity.length()) / gravity
	launch_elapsed = 0.0

	# Faster playback
	var anim: AnimationPlayer = character.animation
	var animation_length: float = anim.get_animation(anim_name).length
	var speed_scale: float = animation_length / launch_duration
	anim.speed_scale = speed_scale
	#print("Speed scale: {0}, Launch Duration: {1}, Animation Length: {2}".format([speed_scale, launch_duration, animation_length]))
	anim.play(anim_name)

func update(delta: float, character: Character, _input: InputController) -> void:
	launch_elapsed += delta

	current_velocity *= damping_factor
	current_velocity.y += gravity * delta / 2

	character.position += current_velocity * delta
	if launch_elapsed >= launch_duration:
		character.is_launched = false

func exit(character: Character) -> void:
	var anim: AnimationPlayer = character.animation
	anim.speed_scale = 1.0
	super(character)
