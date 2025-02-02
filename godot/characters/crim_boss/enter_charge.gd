extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	var boss: Boss = actor
	var controller: EnemyController = boss.input_controller
	controller.current_action = &"charge"
	controller.current_state = InputController.InputState.just_pressed
	
	return SUCCESS
