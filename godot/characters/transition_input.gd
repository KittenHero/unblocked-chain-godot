extends Resource
class_name TransitionInput

@export var from_anim: StringName
@export var anim_state: AnimationState.States
@export var input_combo: Array[NamedInputState]
@export var condition : TransitionCondition = preload("res://characters/player/transition_inputs/empty_condition.tres")
