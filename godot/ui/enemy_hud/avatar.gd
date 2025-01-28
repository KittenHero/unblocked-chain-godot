extends AnimatedSprite2D

class_name Avatar

@onready var sprite : Sprite2D = $Profile

func _ready() -> void:
	sprite.visible = false

func set_boss_frame(boss_name: WorldData.Characters) -> void:
	var frame_map: Dictionary = {
		WorldData.Characters.BOSS: 1,
		WorldData.Characters.JACK: 2,
		WorldData.Characters.JIM: 3,
		WorldData.Characters.KAREN: 4,
	}
	assert(boss_name in frame_map, "New enemy detected, add sprite")
	sprite.frame = frame_map[boss_name]

func _process(_delta: float) -> void:
	if self.frame == 8:
		sprite.visible = true
