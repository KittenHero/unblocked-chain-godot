extends Resource
class_name TransitionCondition

@export_multiline var value: String = ""
var compiled : Expression
var err: Error = OK

func evaluate(current_state: CharacterState, target: CharacterState, character: Character, input: InputController) -> bool:
	if value.is_empty(): return true  
	if compiled == null:
		compiled = Expression.new()
		err = compiled.parse(
			"true" if value.is_empty() else value,
			["current_state", "character", "input"]
		)
		if err != OK:
			print(value)
			print(compiled.get_error_text())
	if err != OK: return false
	var result: Variant = compiled.execute([current_state, character, input], target)
	if compiled.has_execute_failed() or result is not bool:
		return false
	else:
		return result as bool
