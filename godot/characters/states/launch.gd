extends CharacterState

@export var drag : float = 1
var speed_scale : float 

func enter(character: Character) -> void:
	var initial_velocity := character.velocity.length()
	var recovery_velocity := maxf(minf(character.speed, initial_velocity * 0.5), 1.0)
	var launch_duration := maxf(log(initial_velocity / recovery_velocity) / drag, 0.1)
	var anim: AnimationPlayer = character.animation
	var animation_length: float = anim.get_animation(anim_name).length
	speed_scale  = animation_length / launch_duration
	anim.speed_scale *= speed_scale
	anim.play(anim_name)

func update(delta: float, character: Character, _input: InputController) -> void:
	character.velocity *= exp(-drag * delta)

func exit(character: Character) -> void:
	character.is_launched = false
	var anim: AnimationPlayer = character.animation
	anim.speed_scale /= speed_scale
	super(character)
