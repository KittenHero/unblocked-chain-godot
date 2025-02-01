extends CanvasLayer

@export_file("*.tscn", "*.scn") var main_scene: String
@onready var main_menu: PackedScene = preload("res://ui/main_menu.tscn")
@onready var retry_button: Button = %Retry
@onready var menu_button: Button = %Menu

@onready var error_popup: AcceptDialog = %ErrorDialog

func _ready() -> void:
	var err: Error
	if main_scene and main_menu:
		SceneLoader.load_completed.connect(_on_scene_loaded)
		err = SceneLoader.background_load(main_scene)
	else:
		err = ERR_INVALID_DATA
	if err != OK:
		error_popup.show()

func _on_scene_loaded(path: String) -> void:
	if path == main_scene:
		retry_button.disabled = false
		retry_button.visible = true

func _retry() -> void:
	SceneLoader.switch_to_path_scene(main_scene)

func _menu() -> void:
	SceneLoader.switch_to_scene(main_menu)

func _quit() -> void:
	get_tree().quit()
