@tool
extends ActionLeaf

@export var offset : Vector2

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return FAILURE
		
	var character: Boss = actor as Boss 
	var controller: EnemyController = character.input_controller
	var agent: NavigationAgent2D = character.agent 
	var nearest: Character = players[0]
	var dir := 1 if character.position.direction_to(nearest.position).x <= 0 else -1
	var target := nearest.position + dir * offset	
	# Map has never synchronized 
	if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
		return FAILURE

	if agent.get_target_position() != nearest.global_position:
		agent.target_position = target
		
	if agent.is_navigation_finished():
		controller.aim = character.position.direction_to(nearest.position)
		character.update_sprite_direction(controller.aim)
		controller.move = Vector2.ZERO
		
		if character.velocity.length_squared() > 1.0:
			return RUNNING
		return SUCCESS
	
	# TODO: get_next_path_position ideally in physics_process
	var current_position: Vector2 = character.global_position
	var next_path_position: Vector2 = agent.get_next_path_position()

	controller.move = current_position.direction_to(next_path_position)
	return RUNNING
