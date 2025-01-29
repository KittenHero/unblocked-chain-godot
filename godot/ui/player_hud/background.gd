extends AnimatedSprite2D

@onready var sprite: Sprite2D = $Profile

func _ready() -> void:
	sprite.visible = false

func _process(_delta: float) -> void:
	if self.frame == 8:
		sprite.visible = true 
	
