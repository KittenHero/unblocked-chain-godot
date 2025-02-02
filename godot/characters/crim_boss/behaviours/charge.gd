extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var character: Boss = actor
	if (
		not character.current_state.anim_name.containsn("charge") 
		):
		cleanup(character)
		return FAILURE	
	if not blackboard.has_value("charge_target"):
		cleanup(character)
		return FAILURE
			
	var target_position: Vector2 = blackboard.get_value("charge_target")
	var controller: EnemyController = character.input_controller
	controller.move = (target_position - character.global_position).normalized()

	return RUNNING

func cleanup(character: Boss) -> void:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return
		
	var agent: NavigationAgent2D = character.agent 
	var nearest: Character = players[0]
	
	if agent.get_target_position() != nearest.global_position:
		agent.target_position = nearest.global_position
