extends Node

var data := {}

func update(section: String, message: String) -> void:
	data[section] = message

func update_group(group: Dictionary) -> void:
	data.merge(group, true)
