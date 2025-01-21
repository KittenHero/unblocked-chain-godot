extends Control

@export var player_stats: PlayerStats
@export var flicker_amount: float

@onready var background_animation: AnimatedSprite2D = %Background
@onready var health_bar_shader: ShaderMaterial = (%HPBarFill as CanvasItem).material
@onready var stamina_bar_shader: ShaderMaterial = (%StaminaBarFill as CanvasItem).material
var flicker_active : bool = false
var tween : Tween

func _ready() -> void:
	health_bar_shader.set_shader_parameter("progress", 0.0)
	stamina_bar_shader.set_shader_parameter("progress", 0.0)
	background_animation.play("ui_entrance")
	tween = get_tree().create_tween()

func update_bars() -> void:
	var health_progress: float = player_stats.health / player_stats.max_health
	var stamina_progress: float = player_stats.stamina / player_stats.max_stamina
	var displayed_health: float = health_bar_shader.get_shader_parameter("progress")
	var displayed_stamina: float = stamina_bar_shader.get_shader_parameter("progress")	
	tween.stop()
	tween = get_tree().create_tween()
	tween.parallel().tween_method(
		func(value: float) -> void: health_bar_shader.set_shader_parameter("progress", value),
		displayed_health,
		health_progress,
		0.5
		)
	tween.parallel().tween_method(
		func(value: float) -> void: stamina_bar_shader.set_shader_parameter("progress", value),
		displayed_stamina,
		stamina_progress,
		0.5
	)
	tween.play()
	displayed_health = health_progress
	displayed_stamina = stamina_progress

# Signals
func _on_background_animation_finished() -> void:
	SignalManager.player_stat_change.connect(_on_player_stat_change)
	update_bars()
	
func _on_player_stat_change(stat_name: String, value: float) -> void:
	if stat_name not in ["health", "stamina"]: 
		return
	if stat_name == "health":
		player_stats.health = value
	elif stat_name == "stamina":
		player_stats.stamina = value
		
	update_bars()
