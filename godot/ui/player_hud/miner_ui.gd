extends Control

@onready var bar : TextureProgressBar = %TextureProgressBar
@onready var slot_machine : TextureRect = %SlotMachine
@onready var left : Path2D = %LeftWheel
@onready var middle : Path2D = %MiddleWheel
@onready var right : Path2D = %RightWheel
@onready var wheel_stop_sfx : AudioStreamPlayer = %WheelStopSfx
@onready var win_sfx : AudioStreamPlayer = %WinSfx

@export var rps : float = 2.0

var computeNode: UnblockChainMiner
var wheels : Array[Array] = []
var stops : Array[Array] = [[1,1,1], [2,2,2], [3,3,3], [1,2,3], [3,2,1]];

func _ready() -> void:
	# HACK
	computeNode = get_tree().get_first_node_in_group("players").get_node("UnblockChainMiner")
	if computeNode == null:
		hide()
		set_physics_process(false)
	else:
		bar.max_value = computeNode.proof_of_work
		bar.value = computeNode.current_compute
		computeNode.mined.connect(_on_chain_reward)
		var rewards := computeNode.rewarder.rewards
		wheels.append(rewards.duplicate())
		wheels.append(interleave(rewards.duplicate()))
		wheels.append(interleave(rewards.duplicate(), true))

func interleave(original: Array[UnblockChainReward], reverseA: bool = false, reverseB: bool = false) -> Array[UnblockChainReward]:
	var n := original.size()
	@warning_ignore("integer_division")
	var half := (n + 1)/2
	var a := original.slice(0, half)
	var b := original.slice(half, n)
	if reverseA: a.reverse()
	if reverseB: b.reverse()
	
	var interleaved : Array[UnblockChainReward] = []
	var i := 0
	var j := 0
	while i < a.size() or j < b.size():
		if i < a.size():
			interleaved.append(a[i])
			i += 1
		if j < b.size():
			interleaved.append(b[j])
			j += 1
	return interleaved

func _process(_delta: float) -> void:
	if computeNode == null: return
	bar.value = computeNode.current_compute
	if computeNode.overclock_duration > 0:
		(bar.material as ShaderMaterial).set_shader_parameter("speed_multiplier", computeNode.overclock_boost)
	else:
		(bar.material as ShaderMaterial).set_shader_parameter("speed_multiplier", 1.0)

func spin(wheel_data: Array[UnblockChainReward], reward: UnblockChainReward, wheel: Path2D, stop: int, duration: float) -> Tween:
	var target := wheel_data.find(reward)
	var wheel_size := wheel_data.size()
	for slot : Node in wheel.get_children():
		wheel.remove_child(slot)
		slot.queue_free()
	assert(wheel_size > 3, "Wheel too small")
	var tween := get_tree().create_tween()
	for i in range(wheel_size):
		var r := wheel_data[i]
		var pos := PathFollow2D.new()
		pos.cubic_interp = false
		pos.rotates = false
		pos.progress_ratio = 0
		wheel.add_child(pos)
		var sprite := Sprite2D.new()
		sprite.texture = r.icon
		pos.add_child(sprite)
		var start : float = (wheel_size + i - target + stop)
		var final : float = wheel_size*(1 + rps*duration) + i - target + stop
		var subtween := tween.parallel()
		subtween.tween_method(
			follow_wheel.bind(pos, wheel_size),
			start,
			final,
			duration
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_callback(wheel_stop_sfx.play)
	return tween

func follow_wheel(progress: float, wheel_item: PathFollow2D, wheel_size: int) -> void:
	wheel_item.progress_ratio = clampf((int(progress) % wheel_size) + progress - int(progress), 0.0, 4.0) * 0.25

func _on_chain_reward(reward: UnblockChainReward) -> void:
	bar.hide()
	slot_machine.show()
	var stopping : Array = stops.pick_random()
	var duration := computeNode.cooldown_timer
	spin(wheels[0], reward, left, stopping[0] as int, duration * 0.4)
	spin(wheels[1], reward, middle, stopping[1] as int, duration * 0.6)
	var tween = spin(wheels[2], reward, right, stopping[2] as int, duration * 0.8)
	tween.tween_callback(win_sfx.play)
	var sfx_len := win_sfx.stream.get_length()
	win_sfx.volume_db = 0
	tween.tween_interval(sfx_len * 0.8)
	tween.tween_property(win_sfx, "volume_db", -80, 0.2*sfx_len).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(duration).timeout
	bar.show()
	slot_machine.hide()
