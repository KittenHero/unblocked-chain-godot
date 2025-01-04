#@tool
extends Resource
class_name NamedInputState

@export var input_name: StringName
@export var input_type: InputController.InputState

#func _get_property_list() -> Array[Dictionary]:
	#InputMap.load_from_project_settings()
	#return [{
		#"name": "input_name",
		#"type": TYPE_STRING_NAME,
		#"hint": PROPERTY_HINT_ENUM,
		#"hint_string": ",".join(InputMap.get_actions()),
		#"usage": PROPERTY_USAGE_DEFAULT,
	#}]
