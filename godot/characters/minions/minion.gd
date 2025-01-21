extends Character

@export var texture : Texture2D
@export_category("Navigation")
@export var target_sector_angle: float = PI
@export var orbit_radius: float = 200

func _ready() -> void:
	super()
	if texture != null:
		sprite.texture = texture
