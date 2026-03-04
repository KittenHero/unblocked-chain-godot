extends CharacterState

@export var stamina_cost : float = 50
@export var counter : Attack
@export var sfx_player : AudioStreamPlayer2D
@export var sfx : AudioStream
var parried_attack: AttackData = null
var _char : Character

func enter(character: Character) -> void:
	super(character)
	(character as PlayerCharacter).change_stamina(-stamina_cost)
	parried_attack = null
	_char = character

func update(delta: float, character: Character, _input: InputController) -> void:
	character.slow_down(delta)

func exit(character: Character) -> void:
	if parried_attack != null:
		# refund stamina
		(character as PlayerCharacter).change_stamina(stamina_cost)

func _on_parry_area_entered(area: Area2D) -> void:
	if area is not Attack: return
	var attack : Attack = area
	if parried_attack != null and parried_attack.damage >  attack.attack_data.damage: return
	parried_attack = attack.attack_data
	sfx_player.stream = sfx
	sfx_player.play()
	counter.attack_data.damage = parried_attack.damage * 2
