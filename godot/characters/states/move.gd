extends CharacterState

func update(delta: float, character: Character, input: InputController) -> void:
	character.move(delta, input)
