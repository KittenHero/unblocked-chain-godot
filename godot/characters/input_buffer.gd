extends InputController
class_name BufferedCharacterController

var buffer: Array[TimedInput] = []
var used: Array[TimedInput] = []
var pressing := {}
var held: int = 300
@onready var character: Character = self.owner

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
	elif event is InputEventMouse:
		var pos : Vector2 = (character.get_global_mouse_position() - character.global_position).limit_length(1.0)
		var eventx := InputEventAction.new()
		var eventy := InputEventAction.new()
		eventx.pressed = true
		eventy.pressed = true
		eventx.strength = minf(absf(pos.x), 1.0)
		eventy.strength = minf(absf(pos.y), 1.0)
		pressing[&"aim_left"] = TimedInput.new(eventx, te.created)
		pressing[&"aim_right"] = TimedInput.new(eventx, te.created)
		pressing[&"aim_up"] = TimedInput.new(eventy, te.created)
		pressing[&"aim_down"] = TimedInput.new(eventy, te.created)
		if pos.x < 0.0:
			eventx.action = &"aim_left"
			pressing.erase(&"aim_right")
		elif pos.x > 0.0:
			eventx.action = &"aim_right"
			pressing.erase(&"aim_left")
		else:
			pressing.erase(&"aim_left")
			pressing.erase(&"aim_right")
		if pos.y < 0.0:
			eventy.action = &"aim_up"
			pressing.erase(&"aim_down")
		elif pos.y > 0.0:
			eventy.action = &"aim_down"
			pressing.erase(&"aim_up")
		else:
			pressing.erase(&"aim_up")
			pressing.erase(&"aim_down")


func empty() -> bool:
	return pressing.is_empty() and buffer.is_empty()

func matches(action: StringName, state: InputState) -> bool:
	trim_buffer()
	var result : TimedInput = null
	match state:
		InputState.just_pressed:
			result = get_last_pressed(action)
			if result: used.append(result)
			return result != null
		InputState.pressing:
			return pressing.get(action)
		InputState.released:
			return pressing.has(action)
		InputState.tapped:
			if pressing.has(action) or count_pressed(action) != 1: return false
			result = get_last_pressed(action)
			if result: used.append(result)
			return result != null
		_:
			return false

func count_pressed(action: StringName) -> int:
	return buffer.reduce(
		func (accum: int, input: TimedInput) -> int:
			return accum + int(input.event.is_action_pressed(action)),
		0
	)

func get_last_pressed(action: StringName) -> TimedInput:
	var matching := buffer.filter(
		func (input: TimedInput) -> int:
			return input.event.is_action_pressed(action)
	)
	return null if matching.is_empty() else matching.back()

func get_last_released(action: StringName) -> TimedInput:
	var matching := buffer.filter(
		func (input: TimedInput) -> int:
			return input.event.is_action_released(action)
	)
	return null if matching.is_empty() else matching.back()

func get_actions_from(event: InputEvent) -> Array[StringName]:
	return InputMap.get_actions().filter(
		func (action: StringName) -> bool:
			return event.is_action(action)
	)

func trim_buffer() -> void:
	var current_time := Time.get_ticks_msec()
	buffer = buffer.filter(
		func(t: TimedInput) -> bool: return t.created + held >= current_time
	)
	for action : String in pressing.keys():
		if not action.begins_with("aim") and not Input.is_action_pressed(action):
			pressing.erase(action)

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

func get_vector(
	negative_x: StringName,
	positive_x: StringName,
	negative_y: StringName,
	positive_y: StringName,
) -> Vector2:
	var x := get_axis(negative_x, positive_x)
	var y := get_axis(negative_y, positive_y)
	return Vector2(x, y).limit_length(1.0)
