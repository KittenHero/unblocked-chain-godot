extends CanvasLayer

func _ready() -> void:
	visibility_changed.connect(toggle_pause)

func toggle_pause() -> void:
	get_tree().paused = visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and not event.is_echo():
		visible = not visible
