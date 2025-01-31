extends InputController
class_name EnemyController

var current_action: StringName = &""
var current_state: InputState = InputState.released
var matched := false
var aim : Vector2 = Vector2.ZERO
var move : Vector2 = Vector2.ZERO

func empty() -> bool:
	return false

func handle(_event: InputEvent) -> void:
	return

func consume() -> void:
	if matched:
		current_action = &""
		current_state = InputState.released
	return

func matches(action: StringName, state: InputState) -> bool:
	matched = action == current_action and state == current_state
	return matched

func get_axis(_negative: StringName, _positive: StringName) -> float:
	return 0.0

func get_vector(
	negative_x: StringName,
	positive_x: StringName,
	negative_y: StringName,
	positive_y: StringName,
) -> Vector2:
	if (
		negative_x == &"aim_left"
		and positive_x == &"aim_right"
		and negative_y == &"aim_up"
		and positive_y == &"aim_down"
	):
		return aim
	if (
		negative_x == &"move_left"
		and positive_x == &"move_right"
		and negative_y == &"move_up"
		and positive_y == &"move_down"
	):
		return move
	return Vector2.ZERO
