extends StatusCondition
class_name Regen

## per second
@export var heal_over_time := 5
## in seconds
@export var period := 0.1
var heal_timer : Timer

func apply(character: Character) -> void:
	super(character)
	heal_timer = Timer.new()
	heal_timer.wait_time = period
	# HACK
	heal_timer.timeout.connect((character as PlayerCharacter).player_stats.change_health.bind(heal_over_time * period))
	character.add_child(heal_timer)
	heal_timer.start()

func unapply(character: Character) -> void:
	heal_timer.stop()
	heal_timer.queue_free()
	super(character)
