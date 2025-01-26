extends Control

@export var stats: Stats
@export var target_avatar_frame: int

@onready var avatar_animation: AnimatedSprite2D = $Avatar
@onready var background_bar_shader: ShaderMaterial = ($HPBarBackground as CanvasItem).material
@onready var health_bar_shader: ShaderMaterial = ($HPBarFill as CanvasItem).material


func _ready() -> void:
	assert(stats != null)
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

func update_health_bar() -> void:
	var health_progress: float = stats.health / stats.max_health
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
	update_health_bar()

# Signals	
func _on_boss_stat_change(stat_name: String, value: float) -> void:
	if stat_name not in ["health"]: 
		return
	if stat_name == "health":
		stats.health = value
		update_health_bar()

func _on_avatar_frame_changed() -> void:
	print(avatar_animation.frame)
	if avatar_animation.frame == target_avatar_frame:
		complete_animation()		
