class_name AnimationState

## 	For labeling frames of animation
##  so that the state machine know which frames transitions are valid
enum States {

	## can transition to any valid state
	Neutral,

	## should only allow transitions to states with multiple inputs
	## i.e, if a special attack requires pressing attack + parry
	## then we can allow the start up frames of attack to cancel to parry
	Startup,

	## Should not be interrupted
	##
	## unless acted upon by an action where:
	## 	action.interrupt > state.interrupt_resistance
	## eg. getting hit by while doing an attack without having armor
	## this does not have to line up with the actual active hitbox frames
	Busy,

	## similar to start up,
	## but may allow "cancelling" into other states
	## https://glossary.infil.net/?t=Cancel
	Recovery,

	## Should transition to idle
	Finished,

	## should allow automatic transition to the next state
	Queued,

	## allow transition to states based on input timing
	Early,
	OnTime,
	Late
}
