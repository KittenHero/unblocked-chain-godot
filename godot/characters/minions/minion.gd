extends Character

@export var texture : Texture2D

func _ready() -> void:
	super()
	if texture != null:
		sprite.texture = texture
