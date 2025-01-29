extends CanvasLayer

@export var starting_enemy: WorldData.Characters
@onready var boss_view: BossHPView = $BossHpView

func _ready() -> void:
	boss_view.set_starting_sprite(starting_enemy)
