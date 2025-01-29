extends Control

class_name BossHPView

@export var target_avatar_frame: int

@onready var avatar_animation: Avatar = $Avatar
@onready var background_bar_shader: ShaderMaterial = ($HPBarBackground as CanvasItem).material
@onready var health_bar_shader: ShaderMaterial = ($HPBarFill as CanvasItem).material

func _ready() -> void:
	assert(
		avatar_animation.sprite_frames.get_frame_count("avatar") >= target_avatar_frame,
		"Invalid animation completion point"
	)
	avatar_animation.play("avatar")

func prepare_tween() -> Tween:
	return get_tree().create_tween()

func update_background_bar() -> void:
	var tween : Tween = prepare_tween()
	tween.tween_method(
		func(value: float) -> void: background_bar_shader.set_shader_parameter("progress", value),
		0.0,
		1.0,
		0.5
	)
	await tween.finished

func update_health_bar(health_progress: float) -> void:
	var displayed_health: float = health_bar_shader.get_shader_parameter("progress")
	var tween : Tween = prepare_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(
		func(value: float) -> void: health_bar_shader.set_shader_parameter("progress", value),
		displayed_health,
		health_progress,
		0.5
	)
	tween.play()
	displayed_health = health_progress

func complete_animation() -> void:
	await update_background_bar()
	SignalManager.boss_stat_change.connect(_on_boss_stat_change)
	update_health_bar(1.0)

# Avatar
func set_starting_sprite(boss_name: WorldData.Characters) -> void:
	avatar_animation.set_boss_frame(boss_name)

# Signals	
func _on_boss_stat_change(stats: Stats) -> void:
	set_starting_sprite(stats.name)
	update_health_bar(stats.health / stats.max_health)
		

func _on_avatar_frame_changed() -> void:
	print(avatar_animation.frame)
	if avatar_animation.frame == target_avatar_frame:
		complete_animation()		
