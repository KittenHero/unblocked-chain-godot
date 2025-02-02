extends HBoxContainer

@export var character : Character
var icons : Dictionary = {}
@export var icon_tint : Color = Color.hex(0x444444FF)

func _ready() -> void:
	character = get_tree().get_first_node_in_group("players")

func _physics_process(_delta: float) -> void:
	if character == null: return
	for cond : String in icons.keys():
		if not character.active_conditions.has(cond):
			(icons[cond] as Node).queue_free()
			icons.erase(cond)

	for cond : String in character.active_conditions.keys():
		var status : StatusCondition = character.active_conditions[cond]
		if not icons.has(cond):
			var bar := TextureProgressBar.new()
			bar.max_value = status.duration
			bar.step = 0.01
			bar.texture_under = status.icon
			bar.texture_progress = status.icon
			bar.tint_under = icon_tint
			bar.fill_mode = bar.FillMode.FILL_COUNTER_CLOCKWISE
			icons[cond] = bar
			add_child(bar)
		(icons[cond] as TextureProgressBar).value = status.timer.time_left
