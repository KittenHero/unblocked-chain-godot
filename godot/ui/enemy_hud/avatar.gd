extends AnimatedSprite2D

class_name Avatar

@onready var profile : Sprite2D = $Profile
@export var target_avatar_frame: int
signal profile_shown();

func _ready() -> void:
	frame_changed.connect(self._on_frame_changed)
	assert(
		sprite_frames.get_frame_count("avatar") >= target_avatar_frame,
		"Invalid animation completion point"
	)
	profile.hide()

func set_boss_frame(boss_name: WorldData.Characters) -> void:
	var frame_map: Dictionary = {
		WorldData.Characters.BOSS: 1,
		WorldData.Characters.JACK: 2,
		WorldData.Characters.JIM: 3,
		WorldData.Characters.KAREN: 4,
	}
	assert(boss_name in frame_map, "New enemy detected, add sprite")
	profile.frame = frame_map[boss_name]

func _on_frame_changed() -> void:
	if self.frame >= target_avatar_frame and not profile.visible:
		profile.show()
		profile_shown.emit()
		frame_changed.disconnect(self._on_frame_changed)
