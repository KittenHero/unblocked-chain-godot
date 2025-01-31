extends ConditionLeaf

func tick(actor:Node, _blackboard:Blackboard) -> int:
	var boss : Character = actor
	if boss.animation.current_animation == &"boss/big_punch":
		return SUCCESS
	else:
		return FAILURE
