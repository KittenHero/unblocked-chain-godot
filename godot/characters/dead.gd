extends CharacterState

var explode : PackedScene = preload("res://vfx/explosion.tscn")

func enter(character: Character) -> void:
	super(character)
	var explosion : Explosion = explode.instantiate()
	explosion.initialise(character.sprite)
	explosion.global_position = character.global_position
	explosion.scale = character.scale
	explosion.rotation = character.rotation
	character.queue_free()
	get_tree().current_scene.add_child(explosion)
