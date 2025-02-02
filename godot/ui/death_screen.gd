extends CanvasLayer

@export_file("*.tscn", "*.scn") var main_scene: String
@onready var main_menu: PackedScene = preload("res://ui/main_menu.tscn")
@onready var retry_button: Button = %Retry
@onready var menu_button: Button = %Menu

@onready var error_popup: AcceptDialog = %ErrorDialog

func _retry() -> void:
	get_tree().reload_current_scene()

func _menu() -> void:
	SceneLoader.switch_to_scene(main_menu)
