extends Camera2D

@export_category("Player")
@onready var player : CharacterBody2D  = get_tree().get_first_node_in_group(&"camera-follow")
@export var target_offset : Vector2
@export var max_target_offset : Vector2
@export var speed : float = 200.0
@export_category("Camera Shake")
@export_range(0, 1, 0.01) var intensity_multiplier: float = 0.1
@export var min_intensity: float = 0.1
@export var max_intensity: float = 5.0

var target : Vector2

func _ready() -> void:
	if not player:
		set_physics_process(false)
		return
	target = player.position + target_offset
	position = target
	CombatManager.camera_shake.connect(shake)

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

func shake(hitstop_frames: int) -> void:
	if not is_inside_tree():
		return
		
	var duration: float = hitstop_frames / 60.0
	var intensity: float = clamp(
		hitstop_frames * intensity_multiplier, 
		min_intensity, 
		max_intensity
		)
	var tween: Tween = get_tree().create_tween()
	var random_offset: Vector2 = target_offset + Vector2(
		randf_range(-intensity, intensity),
		randf_range(-intensity, intensity)
	)
	
	# 1 shake
	tween.tween_property(
		self, "offset", random_offset, duration / 2
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		self, "offset", target_offset, duration / 2
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	
