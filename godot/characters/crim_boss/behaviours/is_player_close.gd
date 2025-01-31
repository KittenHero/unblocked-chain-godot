extends ConditionLeaf

@export var detection_range: float = 20

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return FAILURE
	var character : Character = actor
	var nearest: Character = players[0]
	for p: Character in players:
		if character.global_position.distance_to(p.global_position) < character.global_position.distance_to(nearest.global_position):
			nearest = p

	if character.global_position.distance_to(nearest.global_position) > detection_range:
		return FAILURE  
		
	return SUCCESS  
