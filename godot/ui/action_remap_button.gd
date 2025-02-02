extends Button
class_name ActionRemapButton

@export var action: StringName
var mapped_event: InputEvent
 
func _ready() -> void:
	set_process_unhandled_key_input(false)
	reload()
	Settings.control_reset.connect(self.reload)
	self.pressed.connect(self._on_pressed)
 
func reload() -> void:
	mapped_event = InputMap.action_get_events(action)[0]
	text = mapped_event.as_text()

func remap_action_to(event: InputEvent) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	Settings.action_remap[action] = event
	Settings.save_data()
	mapped_event = event
	text = event.as_text()
 
func _on_pressed() -> void:
	set_process_unhandled_key_input(true)
	text = "press any key"
 
func _unhandled_key_input(event: InputEvent) -> void:
	remap_action_to(event)
	set_process_unhandled_key_input(false)
	release_focus()
	get_viewport().set_input_as_handled()
