extends Node
class_name CharacterState

enum EnterAnimation {
	QUEUE,
	PLAY,
}
enum ExitAnimation {
	STOP,
	CONTINUE
}

@export var anim_name: StringName
@export var enter_animation := EnterAnimation.PLAY
@export var exit_animation := ExitAnimation.STOP
@export var valid_transitions: Array[TransitionInput] = []

func enter(character: Character) -> void:
	var animation := character.animation
	match enter_animation:
		EnterAnimation.PLAY:
			animation.play(anim_name)
			animation.advance(0)
		EnterAnimation.QUEUE:
			animation.queue(anim_name)

func update(_delta: float, _character: Character, _input: InputController) -> void:
	pass

func exit(character: Character) -> void:
	var animation := character.animation
	match exit_animation:
		ExitAnimation.STOP:
			animation.stop()
		ExitAnimation.CONTINUE:
			pass

func can_transition(current: CharacterState, character: Character, input: InputController) -> bool:
	var input_valid := func(state: NamedInputState) -> bool:
		return input.matches(state.input_name, state.input_type)
	var is_active := func (transition: TransitionInput) -> bool:
		return (
			(
				transition.from_anim == character.animation.current_animation
				or transition.from_anim == current.anim_name
			)
			and transition.anim_state == character.animation_state
			and transition.condition.evaluate(current, self, character, input)
			and transition.input_combo.all(input_valid)
		)
	return valid_transitions.any(is_active)
