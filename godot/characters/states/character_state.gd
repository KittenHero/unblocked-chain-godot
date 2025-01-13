extends Node
class_name CharacterState

@export var anim_name: StringName
@export_range(0, 100) var interrupt_resistance: float = 0.0
@export var valid_transitions: Array[TransitionInput] = []

func enter(character: Character) -> void:
	var animation := character.animation
	animation.play(anim_name)
	animation.advance(0)

func update(_delta: float, _character: Character, _input: InputController) -> void:
	pass

func exit(character: Character) -> void:
	pass

func can_transition(current: CharacterState, character: Character, input: InputController) -> bool:
	var input_valid := func(state: NamedInputState) -> bool:
		return input.matches(state.input_name, state.input_type)
	var is_active := func (transition: TransitionInput) -> bool:
		return (
			(
				transition.from_anim.is_empty()
				or transition.from_anim == current.anim_name
			)
			and transition.anim_state == character.animation_state
			and transition.condition.evaluate(current, self, character, input)
			and transition.input_combo.all(input_valid)
		)
	return valid_transitions.any(is_active)
