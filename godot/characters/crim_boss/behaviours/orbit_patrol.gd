extends ActionLeaf

@export var move_threshold: float = 10

func tick(actor: Node, blackboard: Blackboard) -> int:
	var character: Character = actor
	var controller: EnemyController = character.input_controller

	var orbit_path_str: Variant = blackboard.get_value("orbit_path")
	if orbit_path_str == null:
		orbit_path_str = ""
	var orbit_path: Array[Vector2] = _parse_orbit_path(orbit_path_str as String)

	if orbit_path.is_empty():
		return FAILURE

	var current_target: Vector2 = orbit_path.front() 

	if character.global_position.distance_to(current_target) < move_threshold:
		orbit_path.pop_front()  
		blackboard.set("orbit_path", _format_orbit_path(orbit_path)) 

	controller.move = character.global_position.direction_to(current_target)
	controller.aim = controller.move 
	
	if orbit_path.size() == 0:
		return FAILURE 

	return RUNNING

func _format_orbit_path(orbit_path: Array[Vector2]) -> String:
	var path_strings: Array[String] = []
	for point: Vector2 in orbit_path:
		path_strings.append("{0},{1}".format([point.x, point.y])) 
	return ";".join(path_strings)

func _parse_orbit_path(path_string: String) -> Array[Vector2]:
	var orbit_path: Array[Vector2] = []

	if path_string.is_empty():
		return orbit_path
		
	var point_strings: PackedStringArray = path_string.split(";")
	for point_str: String in point_strings:
		var coords: PackedStringArray = point_str.split(",")
		if coords.size() == 2:
			orbit_path.append(Vector2(coords[0].to_float(), coords[1].to_float()))

	return orbit_path
