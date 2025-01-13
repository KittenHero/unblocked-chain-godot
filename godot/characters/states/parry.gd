extends CharacterState

func update(delta: float, character: Character, _input: InputController) -> void:
	character.slow_down(delta)
