extends CanvasLayer

@export_file("*.tscn", "*.scn") var main_scene : String
@onready var menu_button: Button = %Menu
@onready var error_popup: AcceptDialog = %ErrorDialog

func _ready() -> void:
	var err: Error
	if main_scene:
		err = SceneLoader.background_load(main_scene)
		SceneLoader.load_completed.connect(_on_scene_loaded)
	else:
		err = ERR_INVALID_DATA
	print(err)
	if err != OK:
		error_popup.show()

func _on_scene_loaded(path: String) -> void:
	if path != main_scene: return
	SceneLoader.load_completed.disconnect(_on_scene_loaded)

func _start() -> void:
	get_tree().change_scene_to_packed(SceneLoader.get_packed_scene(main_scene))
