extends ActionLeaf

@export var threshold : float = 5.0
@export var player_proximity_threshold : float = 15.0

func tick(actor:Node, _blackboard:Blackboard) -> int:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty(): return FAILURE
	
	var target_sector_angle: float = actor.get("target_sector_angle")
	var orbit_radius: float = actor.get("orbit_radius")

	var minion : Character = actor
	var controller: MinionController = minion.input_controller
	
	var nearest: Character = players[0]
	for p: Character in players:
		if minion.position.distance_to(p.position) < minion.position.distance_to(nearest.position):
			nearest = p
			#
	### Check proximity 
	#var distance_to_player: float = minion.position.distance_to(nearest.position)
	#if distance_to_player < player_proximity_threshold:
		#controller.aim = minion.position.direction_to(nearest.position)
		#controller.move = Vector2.ZERO
		#return SUCCESS
	
	# Some variance
	var target_fps: float = 60.0
	var oscillation_amplitude : float = 0.7
	var time : float = Engine.get_frames_drawn() / target_fps
	var angle_with_variance : float = target_sector_angle + sin(time)*oscillation_amplitude
	
	var target_position : Vector2 = nearest.position + Vector2(
		orbit_radius * cos(angle_with_variance),
		orbit_radius * sin(angle_with_variance)
	)
	
	#if is_player_between(minion.position, target_position, nearest.position):
		#var dir_to_player: Vector2 = (nearest.position - minion.position).normalized()
		#controller.move = dir_to_player
		#if distance_to_player < player_proximity_threshold:
			## In range
			#controller.aim = minion.position.direction_to(nearest.position)
			#controller.move = Vector2.ZERO
			#return SUCCESS
		#return RUNNING
	
	var dir : Vector2 = (target_position - minion.position).normalized()
	
	# Movement
	if minion.position.distance_to(target_position) > threshold:
		controller.move = dir
		return RUNNING
	
	# In range
	controller.aim = minion.position.direction_to(nearest.position)
	controller.move = Vector2.ZERO

	if minion.velocity.length_squared() < 1.0:
		return RUNNING
	
	return SUCCESS

func is_player_between(minion_pos: Vector2, target_pos: Vector2, player_pos: Vector2) -> bool:
	var to_target: Vector2 = (target_pos - minion_pos).normalized()
	var to_player: Vector2 = (player_pos - minion_pos).normalized()
	
	var alignment: float = to_target.dot(to_player)
	if alignment < 0.9:
		return false
	
	var dist_to_player : float = minion_pos.distance_to(player_pos)
	var dist_to_target : float = minion_pos.distance_to(target_pos)
	
	return dist_to_player < dist_to_target 
