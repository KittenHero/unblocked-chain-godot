extends ActionLeaf

@export var orbit_range: float = 80
@export var max_orbit_points: int = 3
@export var update_distance_threshold: float = 200

func tick(actor: Node, blackboard: Blackboard) -> int:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return FAILURE

	var character: Character = actor
	var nearest: Character = players[0]

	for p: Character in players:
		if character.global_position.distance_to(p.global_position) < character.global_position.distance_to(nearest.global_position):
			nearest = p

	var player_position: Vector2 = nearest.global_position

	var orbit_path_str: Variant = blackboard.get_value("orbit_path")
	if orbit_path_str == null:
		orbit_path_str = ""
	var orbit_path: Array[Vector2] = _parse_orbit_path(orbit_path_str as String)

	if orbit_path.is_empty():
		orbit_path.clear()
		for i in range(max_orbit_points):
			var angle: float = (PI * 2 / max_orbit_points) * i 
			var orbit_point: Vector2 = player_position + Vector2(cos(angle), sin(angle)) * orbit_range
			orbit_path.append(orbit_point)
			blackboard.set_value("orbit_path", _format_orbit_path(orbit_path))

	return SUCCESS  

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
	for point_str in point_strings:
		var coords: PackedStringArray = point_str.split(",")
		if coords.size() == 2:
			orbit_path.append(Vector2(coords[0].to_float(), coords[1].to_float()))

	return orbit_path
