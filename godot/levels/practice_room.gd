extends Node2D

var sector_reassignment_interval : float = 20.0  
var orbit_radius : float = 50.0
var minions : Array[Node] = []

func _ready() -> void:
	minions = get_tree().get_nodes_in_group("minions")
	assign_sectors()

	var timer: Timer = Timer.new()
	timer.wait_time = sector_reassignment_interval
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)


func assign_sectors() -> void:
	var num_minions : int = minions.size()
	
	var angles: Array = []
	for i in range(num_minions):
		var sector_angle : float = i * (2 * PI / num_minions)
		angles.append(sector_angle)
		
	angles.shuffle()
	
	for i in range(num_minions):	 
		minions[i].set("target_sector_angle", angles[i])
		minions[i].set("orbit_radius", orbit_radius)

func _on_timer_timeout() -> void:
	assign_sectors()
