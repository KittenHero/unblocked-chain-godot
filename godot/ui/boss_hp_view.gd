extends Control

@export var stats: Stats

@onready var background_animation: AnimatedSprite2D = $Background
@onready var health_bar_shader: ShaderMaterial = ($HPBarFill as CanvasItem).material

func _ready() -> void:
	assert(stats != null)
	health_bar_shader.set_shader_parameter("progress", 0.0)
	background_animation.play("ui_entrance")

func prepare_tween() -> Tween:
	return get_tree().create_tween()

func update_health_bar() -> void:
	var health_progress: float = stats.health / stats.max_health
	var displayed_health: float = health_bar_shader.get_shader_parameter("progress")
	var tween : Tween = prepare_tween()
	tween.parallel().tween_method(
		func(value: float) -> void: health_bar_shader.set_shader_parameter("progress", value),
		displayed_health,
		health_progress,
		0.5
	)
	tween.play()
	displayed_health = health_progress

# Signals
func _on_background_animation_finished() -> void:
	SignalManager.boss_stat_change.connect(_on_boss_stat_change)
	update_health_bar()
	
func _on_boss_stat_change(stat_name: String, value: float) -> void:
	if stat_name not in ["health"]: 
		return
	if stat_name == "health":
		stats.health = value
		update_health_bar()
