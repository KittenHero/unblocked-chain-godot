extends ActionLeaf

@export var offset : Vector2
@export var threshold : float = 5.0

func tick(actor:Node, _blackboard:Blackboard) -> int:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty(): return FAILURE
	var minion : Character = actor
	var controller: MinionController = minion.input_controller
	
	var nearest: Character = players[0]
	for p: Character in players:
		if minion.position.distance_to(p.position) < minion.position.distance_to(nearest.position):
			nearest = p
	var dir := 1 if minion.position.direction_to(nearest.position).x <= 0 else -1
	var target := nearest.position + dir * offset
	if minion.position.distance_to(target) > threshold:
		controller.move = minion.position.direction_to(target)
		return RUNNING
	controller.aim = minion.position.direction_to(nearest.position)
	controller.move = Vector2.ZERO
	if minion.velocity.length_squared() < 1.0:
		return RUNNING
	return SUCCESS
