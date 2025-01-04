extends RefCounted
class_name TimedInput

var event: InputEvent
var created: int

func _init(input: InputEvent, current_time: int) -> void:
	event = input
	created = current_time
