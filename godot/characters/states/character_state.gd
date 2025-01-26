extends Node
class_name CharacterState

@export var anim_name: StringName
@export_range(0, 100) var interrupt_resistance: float = 0.0
@export var valid_transitions: Array[TransitionInput] = []
var interruptible: Array[String] =  ["flinch", "launch"]

func enter(character: Character) -> void:
	var animation := character.animation
	animation.play(anim_name)
	animation.advance(0)

func update(_delta: float, _character: Character, _input: InputController) -> void:
	pass

func exit(_character: Character) -> void:
	pass
	
func can_interrupt(target_state: String) -> bool:
	return interruptible.any(func(state: String) -> bool: 
		return target_state.contains(state)) 

func can_transition(current: CharacterState, character: Character, input: InputController) -> bool:
	var input_valid := func(state: NamedInputState) -> bool:
		return input.matches(state.input_name, state.input_type)

	var is_active := func (transition: TransitionInput) -> bool:
		return (
			(
				transition.from_anim.is_empty()
				or transition.from_anim == current.anim_name
			)
			and 
			(
				transition.anim_state == character.animation_state
				or can_interrupt(current.anim_name)
			)
			and transition.condition.evaluate(current, self, character, input)
			and transition.input_combo.all(input_valid)
		)
	return valid_transitions.any(is_active)
