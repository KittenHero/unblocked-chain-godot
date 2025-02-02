extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
	
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return FAILURE
	var character : Character = actor
	var controller: EnemyController = character.input_controller
	var nearest: Character = players[0]
	
	controller.aim = character.position.direction_to(nearest.position)
	
	controller.current_action = &"attack"
	controller.current_state = InputController.InputState.just_pressed
	return SUCCESS
