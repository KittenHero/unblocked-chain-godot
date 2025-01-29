extends GPUParticles2D
class_name Explosion

func initialise(sprite: Sprite2D) -> void:
	var shader_material := process_material as ShaderMaterial
	shader_material.set_shader_parameter("sprite", sprite.texture)
	shader_material.set_shader_parameter("vframes", sprite.vframes)
	shader_material.set_shader_parameter("hframes", sprite.hframes)
	shader_material.set_shader_parameter("frame", sprite.frame)
	@warning_ignore("integer_division")
	amount = sprite.texture.get_width() * sprite.texture.get_height() / (sprite.hframes * sprite.vframes)
	emitting = true
