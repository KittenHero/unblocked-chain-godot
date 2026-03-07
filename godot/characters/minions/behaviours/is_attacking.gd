@tool
extends ConditionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
	var minion : Character = actor
	if minion.animation.current_animation == &"minion/attack":
		return SUCCESS
	else:
		return FAILURE
