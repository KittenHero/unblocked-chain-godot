extends Control

@export var player_stats: PlayerStats
@export var flicker_amount: float

@onready var background_animation: AnimatedSprite2D = $Background
@onready var health_bar_fill: Sprite2D = $HPBarFill
@onready var stamina_bar_fill: Sprite2D = $StaminaBarFill

var flicker_active : bool = false

func _ready() -> void:
	SignalManager.player_stat_change.connect(_on_player_stat_change)

	background_animation.play("ui_entrance")

func update_bars() -> void:
	var health_progress: float = player_stats.health / player_stats.max_health
	var stamina_progress: float = player_stats.stamina / player_stats.max_stamina
	print("Health remaining - {0}%".format([health_progress*100]))
	health_bar_fill.material.set("progress", health_progress)
	stamina_bar_fill.material.set("progress", stamina_progress)
	#todo fix	
	#var health_tween = create_tween()
	#var initial_health = health_bar_fill.material.get("progress")
	#health_tween.tween_method(
		#func(value) -> void: health_bar_fill.material.set("progress", value),
		#initial_health,
		#health_progress,
		#2.0
		#)
	#
	#var stamina_tween = create_tween()
	#var initial_stamina = stamina_bar_fill.material.get("progress")
	#stamina_tween.tween_method(
		#func(value) -> void: stamina_bar_fill.material.set("progress", value),
		#initial_stamina,
		#stamina_progress,
		#2.0
	#)
# Signals
func _on_background_animation_finished() -> void: 
	health_bar_fill.visible = true
	stamina_bar_fill.visible = true
	
func _on_player_stat_change(stat_name: String, value: float) -> void:
	if stat_name not in ["health", "stamina"]: 
		return
	if stat_name == "health":
		player_stats.health = value
	elif stat_name == "stamina":
		player_stats.stamina = value
		
	update_bars()
