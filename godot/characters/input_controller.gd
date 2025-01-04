extends Node
class_name InputController

enum InputState {
	just_pressed,
	pressing,
	released,
	tapped,
}

func empty() -> bool:
	return true

func handle(_event: InputEvent) -> void:
	pass

func consume() -> void:
	pass

func matches(_name: StringName, _state: InputState) -> bool:
	return false

func get_axis(_negative: StringName, _positive: StringName) -> float:
	return 0.0

func get_dual_axis(
	_negative_x: StringName,
	_positive_x: StringName,
	_negative_y: StringName,
	_positive_y: StringName,
) -> Vector2:
	return Vector2.ZERO
