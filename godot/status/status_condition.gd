extends Resource
class_name StatusCondition

@export var icon : Texture2D
@export var duration : float
@export var name : String

var timer : SceneTreeTimer
var handler : Callable

func apply(character: Character) -> void:
	if character.active_conditions.has(name):
		var existing : StatusCondition = character.active_conditions[name]
		if existing.timer.time_left >= self.duration: return
		existing.unapply(character)
	timer = character.get_tree().create_timer(duration)
	handler = unapply.bind(character)
	timer.timeout.connect(handler)
	character.active_conditions[name] = self

func unapply(character: Character) -> void:
	character.active_conditions.erase(name)
	timer.timeout.disconnect(handler)
