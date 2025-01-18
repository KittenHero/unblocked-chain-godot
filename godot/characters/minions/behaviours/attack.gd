extends ActionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
	var minion : Character = actor
	var controller: MinionController = minion.input_controller
	controller.current_action = &"attack"
	controller.current_state = InputController.InputState.just_pressed
	return SUCCESS
