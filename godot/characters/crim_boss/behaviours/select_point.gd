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

	var player_position: Vector2 = nearest.global_position
	var direction: Vector2 = (nearest.global_position - actor.global_position).normalized()

	return SUCCESS
