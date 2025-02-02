extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var boss: Boss = actor
	
	if boss.animation.name.containsn("idle") or boss.animation.name.containsn("charge"):
		return SUCCESS
	else: 
		return FAILURE
