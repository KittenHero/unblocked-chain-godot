extends CharacterState

func enter(character: Character) -> void:
	super(character)
	character.input_controller = InputController.new()

func update(delta: float, character: Character, input: InputController) -> void:
	character.move(delta, input)
	
func exit(character: Character) -> void:
	super(character)
	character.input_controller = character.get_node("%InputController")
