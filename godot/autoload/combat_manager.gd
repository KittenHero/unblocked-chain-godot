extends Node

# Combat tracker 
# TODO: Add counter logic?

signal camera_shake(frames: int)

# When more than one strike, victim may escape frames earlier 
# than second attacker
func synchronize_hitstop(attack_data: AttackData, nodes: Array[Node2D]) -> void:
	assert(len(nodes) == 2, "Sync only between two")

	var attacker: Character = nodes[0]
	var victim: Character = nodes[1]
	var attacker_frames: int = attack_data.attack_hitstop_frames
	var victim_frames: int = attack_data.victim_hitstop_frames
	var max_frames: int = max(
		attacker_frames,
		victim_frames
	)
	var min_frames: int = min(
		attacker_frames,
		victim_frames
	)
	
	for node: Character in nodes:
		node.start_hitstop()
	
	await get_tree().physics_frame
	camera_shake.emit(min_frames)

	for i in range(max_frames):
		await get_tree().physics_frame
		
		if i == attacker_frames - 1 and is_instance_valid(attacker):
			attacker.end_hitstop()
		
		if i == victim_frames - 1 and is_instance_valid(victim):
			victim.end_hitstop() 

	
