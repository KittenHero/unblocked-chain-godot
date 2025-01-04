extends Camera2D

@onready var player : CharacterBody2D  = get_tree().get_first_node_in_group(&"camera-follow")
@export var target_offset : Vector2
@export var max_target_offset : Vector2
@export var speed : float = 200.0
var target : Vector2

func _ready() -> void:
	if not player:
		set_physics_process(false)
		return
	target = player.position + target_offset
	position = target

func _physics_process(delta: float) -> void:
	if player.velocity.x > 0:
		target.x = player.position.x + target_offset.x
	elif player.velocity.x < 0:
		target.x = player.position.x - target_offset.x
	if player.velocity.y > 0:
		target.y = player.position.y + target_offset.y
	elif player.velocity.y < 0:
		target.y = player.position.y - target_offset.y
	var p := position + minf(speed * delta, position.distance_to(target)) * position.direction_to(target)
	position = p.clamp(
		player.position - max_target_offset,
		player.position + max_target_offset
	)
