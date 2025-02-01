extends CharacterState

## peak dash speed relative to character speed
@export var speed_multiplier := 2
@export var speed_curve : Curve
@export var stamina_cost : float = 50

var direction := Vector2.ZERO

func enter(character: Character) -> void:
	super(character)
	(character as PlayerCharacter).change_stamina(-stamina_cost)
	direction = character.input_controller.get_vector(
		&"move_left", &"move_right", &"move_up", &"move_down"
	).normalized()
	if direction == Vector2.ZERO:
		direction = -Vector2.from_angle(character.facing.rotation)
	character.update_sprite_direction(direction)

func update(_delta: float, character: Character, _input: InputController) -> void:
	var anim :=	character.animation
	var progress := anim.current_animation_position / anim.current_animation_length
	character.velocity = direction * speed_multiplier * character.speed * speed_curve.sample(progress)
