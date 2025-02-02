extends CanvasLayer

@export_file("*.tscn", "*.scn") var main_scene : String
@onready var progress_bar: TextureProgressBar = %ProgressBar
@onready var start_button: Button = %Start
@onready var settings_button: Button = %Settings
@onready var error_popup: AcceptDialog = %ErrorDialog
@onready var loading : Label = %Loading

func _ready() -> void:
	settings_button.grab_focus()
	var err: Error
	if main_scene:
		err = SceneLoader.background_load(main_scene)
		SceneLoader.load_completed.connect(_on_scene_loaded)
	else:
		err = ERR_INVALID_DATA
	if err != OK:
		error_popup.show()

func _process(_delta: float) -> void:
	progress_bar.value = 100.0 * SceneLoader.progress[0]

func _on_scene_loaded(path: String) -> void:
	if path != main_scene: return
	loading.hide()
	start_button.show()
	SceneLoader.load_completed.disconnect(_on_scene_loaded)

func _start() -> void:
	SceneLoader.switch_to_path_scene(main_scene)

func _quit() -> void:
	get_tree().quit()
