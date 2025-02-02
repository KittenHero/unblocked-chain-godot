extends Control

@export var player_stats: PlayerStats

@onready var background_animation: AnimatedSprite2D = %Background
@onready var health_bar_bg: ShaderMaterial = (%HPBarBG as CanvasItem).material
@onready var health_bar: ShaderMaterial = (%HPBarFill as CanvasItem).material
@onready var stamina_bar: ShaderMaterial = (%StaminaBarFill as CanvasItem).material

var tween : Tween

func _ready() -> void:
	custom_minimum_size = background_animation.sprite_frames.get_frame_texture("ui_entrance", 0).get_size()
	health_bar.set_shader_parameter("progress", 0.0)
	health_bar_bg.set_shader_parameter("progress", 0.0)
	stamina_bar.set_shader_parameter("progress", 0.0)
	background_animation.play("ui_entrance")

func prepare_tween() -> Tween:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	return tween

func tween_shader_param(shader: ShaderMaterial, param: String, value: float, duration: float) -> void:
	var current: float = shader.get_shader_parameter(param)
	tween.parallel().tween_method(
		func (v: float) -> void: shader.set_shader_parameter(param, v),
		current,
		value,
		duration
	)

func update_health_bar() -> void:
	var health_progress: float = player_stats.health / player_stats.max_health
	health_bar.set_shader_parameter("progress", health_progress)
	prepare_tween()
	tween_shader_param(health_bar_bg, "progress", health_progress, 1.0)
	tween.play()

func update_stamina_bar() -> void:
	var stamina_progress: float = player_stats.stamina / player_stats.max_stamina
	stamina_bar.set_shader_parameter("progress", stamina_progress)

# Signals
func _on_background_animation_finished() -> void:
	SignalManager.player_stat_change.connect(_on_player_stat_change)
	prepare_tween()
	tween_shader_param(health_bar, "progress", 1.0, 1.0)
	tween_shader_param(stamina_bar, "progress", 1.0, 1.0)
	tween_shader_param(health_bar_bg, "progress", 1.0, 1.0)
	tween.play()
	
func _on_player_stat_change(stat_name: String, value: float) -> void:
	if stat_name not in ["health", "stamina"]: 
		return
	if stat_name == "health":
		player_stats.health = value
		update_health_bar()
	elif stat_name == "stamina":
		player_stats.stamina = value
		update_stamina_bar()
