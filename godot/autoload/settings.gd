extends Node

const PATH = "user://settings.cfg"

@onready var master_index := AudioServer.get_bus_index("Master")
@export var master_volume := 1.0:
	set(value):
		master_volume = value
		AudioServer.set_bus_volume_db(master_index, linear_to_db(value))

@onready var bgm_index := AudioServer.get_bus_index("BGM")
@export var bgm_volume := 1.0:
	set(value):
		bgm_volume = value
		AudioServer.set_bus_volume_db(bgm_index, linear_to_db(value))

@onready var sfx_index := AudioServer.get_bus_index("SFX")
@export var sfx_volume := 1.0:
	set(value):
		sfx_volume = value
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))

@onready var slot_index := AudioServer.get_bus_index("SlotMachine")
@export var slot_volume := 1.0:
	set(value):
		slot_volume = value
		AudioServer.set_bus_volume_db(slot_index, linear_to_db(value))

@export var action_remap := {}:
	set(value):
		action_remap = value
		control_reset.emit()
		save_data()
	
signal control_reset();

func _ready() -> void:
	load_data()

func save_data() -> void:
	var config := ConfigFile.new()
	config.set_value("Audio", "master", master_volume)
	config.set_value("Audio", "bgm", bgm_volume)
	config.set_value("Audio", "sfx", sfx_volume)
	config.set_value("Audio", "slot_machine", slot_volume)
	for action : String in action_remap:
		config.set_value("Keybind", action, action_remap[action])
	config.save(PATH)
	

func load_data() -> void:
	var config := ConfigFile.new()
	if config.load(PATH) != OK: return
	master_volume = config.get_value("Audio", "master", 1.0)
	bgm_volume = config.get_value("Audio", "bgm", 1.0)
	sfx_volume = config.get_value("Audio", "sfx", 1.0)
	slot_volume = config.get_value("Audio", "slot_machine", 1.0)
	if not config.has_section("Keybind"): return
	for action in config.get_section_keys("Keybind"):
		var value: InputEvent = config.get_value("Keybind", action)
		action_remap[action] = value
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, value)
