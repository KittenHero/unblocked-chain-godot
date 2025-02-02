extends CharacterState

@export var duration: int = 10 
var timer: Timer = null

func enter(character: Character) -> void:
	var animation: AnimationPlayer = character.animation
	character.animation_state = AnimationState.States.Busy
	animation.speed_scale = 2
	animation.play(anim_name)
	animation.advance(0)

	timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.autostart = true
	character.add_child(timer)
	timer.timeout.connect(end_animation.bind(character))

func update(delta: float, character: Character, input: InputController) -> void:
	super(delta, character, input)
	character.move(delta*2, input)

func exit(character: Character) -> void:
	if timer and !timer.is_stopped():
		timer.stop()
		end_animation(character)
	if timer and timer.is_inside_tree():
		timer.queue_free()
	timer = null

func end_animation(character: Character) -> void:
	character.animation_state = AnimationState.States.Finished
	(character.input_controller as EnemyController).move = Vector2.ZERO
	character.velocity = Vector2.ZERO
	character.animation.speed_scale = 1
	exit(character)
	
