extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return FAILURE

	var character: Boss = actor
	var nearest: Character = players[0]
	var agent: NavigationAgent2D = character.agent

	for p: Character in players:
		if character.global_position.distance_to(p.global_position) < character.global_position.distance_to(nearest.global_position):
			nearest = p
			
	if (
		blackboard.has_value("charge_target") 
		and agent.is_target_reachable() 
		and agent.target_position == blackboard.get_value("charge_target")
		):
		return FAILURE
		 
	var player_position: Vector2 = nearest.global_position
	var offset_direction: Vector2 = (character.global_position - player_position).normalized()
	var target_position: Vector2 = player_position + (offset_direction * 100)

	agent.target_position = target_position
	blackboard.set_value("charge_target", target_position)

	return SUCCESS  
