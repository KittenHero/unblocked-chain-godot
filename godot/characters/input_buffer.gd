extends InputController
class_name BufferedCharacterController

var buffer: Array[TimedInput] = []
var used: Array[TimedInput] = []
var pressing := {}
var held: int = 300

func handle(event: InputEvent) -> void:
	if event.is_echo(): return
	trim_buffer()
	var te := TimedInput.new(event, Time.get_ticks_msec())
	buffer.append(te)
	if event.is_pressed() and event.is_action_type():
		for action in get_actions_from(event):
			pressing[action] = te
	elif event.is_released() and event.is_action_type():
		for action in get_actions_from(event):
			pressing.erase(action)

func empty() -> bool:
	return pressing.is_empty() and buffer.is_empty()

func matches(action: StringName, state: InputState) -> bool:
	trim_buffer()
	var result : bool
	match state:
		InputState.just_pressed:
			result = count_pressed(action) == 1
			if result: used.append(pressing.get(action))
			return result
		InputState.pressing:
			return pressing.has(action)
		InputState.released:
			return not pressing.has(action)
		InputState.tapped:
			result = not pressing.has(action) and count_pressed(action) == 1
			if result: used.append(pressing.get(action))
			return result
		_:
			return false

func count_pressed(action: StringName) -> int:
	return buffer.reduce(
		func (accum: int, input: TimedInput) -> int:
			return accum + int(input.event.is_action_pressed(action)),
		0
	)

func count_unpressed(action: StringName) -> int:
	return buffer.reduce(
		func (accum: int, input: TimedInput) -> int:
			return accum + int(input.event.is_action_released(action)),
		0
	)

func get_actions_from(event: InputEvent) -> Array[StringName]:
	return InputMap.get_actions().filter(
		func (action: StringName) -> bool:
			return InputMap.action_has_event(action, event)
	)

func trim_buffer() -> void:
	var current_time := Time.get_ticks_msec()
	buffer = buffer.filter(
		func(t: TimedInput) -> bool: return t.created + held >= current_time
	)

func consume() -> void:
	buffer = buffer.filter(func(t: TimedInput) -> bool: return t not in used)
	used.clear()

func get_axis(negative: StringName, positive: StringName) -> float:
	trim_buffer()
	var neg : TimedInput = pressing.get(negative)
	var pos : TimedInput = pressing.get(positive)
	if neg != null and pos != null:
		if neg.created < pos.created:
			return -neg.event.get_action_strength(negative)
		else:
			return pos.event.get_action_strength(positive)
	if pos != null:
		return pos.event.get_action_strength(positive)
	if neg != null:
		return -neg.event.get_action_strength(negative)
	return 0.0

func get_dual_axis(
	negative_x: StringName,
	positive_x: StringName,
	negative_y: StringName,
	positive_y: StringName,
) -> Vector2:
	var x := get_axis(negative_x, positive_x)
	var y := get_axis(negative_y, positive_y)
	return Vector2(x, y)
