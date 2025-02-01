extends Node

var loading: String = ""
var progress: Array[float] = []

signal load_completed(path: String);

func _process(_delta: float) -> void:
	if not loading.is_empty() and load_status(loading) >= 100.0:
		load_completed.emit(loading)
		loading = ""
		set_process(false)
	
func load_status(path: String) -> float:
	var status := ResourceLoader.load_threaded_get_status(path, progress)
	if status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE or status == ResourceLoader.THREAD_LOAD_FAILED:
		return -100
	return 100 * progress[0]

func background_load(path: String) -> Error:
	if not loading.is_empty(): return ERR_UNAVAILABLE
	loading = path
	# Stores it in cache
	var err := ResourceLoader.load_threaded_request(path)
	set_process(true)
	return err

func get_packed_scene(path: String) -> PackedScene:
	return ResourceLoader.load_threaded_get(path) as PackedScene

func switch_to_path_scene(path: String) -> void:
	switch_to_scene(get_packed_scene(path))

func switch_to_scene(packed_scene: PackedScene) -> void:
	if packed_scene == null:
		get_tree().call_deferred("unload_current_scene")
	get_tree().call_deferred("change_scene_to_packed", packed_scene)
