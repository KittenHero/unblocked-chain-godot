extends CanvasLayer

@export_file("*.tscn", "*.scn") var main_scene: String
@onready var main_menu: PackedScene = preload("res://ui/main_menu.tscn")
@onready var retry_button: Button = %Retry
@onready var menu_button: Button = %Menu

func _ready() -> void:
	var _err: Error
	if main_scene:
		_err = SceneLoader.background_load(main_scene)
		SceneLoader.load_completed.connect(_on_scene_loaded)
	else:
		_err = ERR_INVALID_DATA

func _on_scene_loaded(path: String) -> void:
	if path != main_scene: return
	SceneLoader.load_completed.disconnect(_on_scene_loaded)

func _retry() -> void:
	SceneLoader.reload_current_scene()

func _menu() -> void:
	SceneLoader.switch_to_scene(main_menu)
