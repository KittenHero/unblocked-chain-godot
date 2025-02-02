extends AnimatedSprite2D

@onready var profile: Sprite2D = $Profile
@export var target_frame: int

func _ready() -> void:
	frame_changed.connect(self._on_frame_changed)
	assert(
		sprite_frames.get_frame_count("ui_entrance") >= target_frame,
		"Invalid animation completion point"
	)
	profile.hide()

func _on_frame_changed() -> void:
	if self.frame >= target_frame and not profile.visible:
		profile.show()
		frame_changed.disconnect(self._on_frame_changed)
	
