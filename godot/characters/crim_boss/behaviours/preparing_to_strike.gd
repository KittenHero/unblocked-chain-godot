extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	var character: Boss = actor
	if !character.animation.name.containsn("idle"):
		return FAILURE
	return SUCCESS
