extends Control

@export var template_label : Label
@export var template_slider: Range
@export var container : Container
@onready var debouncer : Timer = %Debouncer
var samples : Dictionary = {}

func _ready() -> void:
	for i in range(AudioServer.bus_count):
		var label : Label = template_label.duplicate()
		label.text = AudioServer.get_bus_name(i)
		var slider : Slider = template_slider.duplicate()
		slider.value = db_to_linear(AudioServer.get_bus_volume_db(i))
		slider.value_changed.connect(self.on_volume_value_changed.bind(i))

		container.add_child(label)
		container.add_child(slider)

	template_label.hide()
	template_slider.hide()

	for sound : AudioStreamPlayer in %Samples.get_children():
		samples[AudioServer.get_bus_index(sound.bus)] = sound
		debouncer.timeout.connect(sound.stop)
	debouncer.timeout.connect(Settings.save_data)


func on_volume_value_changed(volume: float, bus: int) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(volume))
	debouncer.start(1)
	if not samples.has(bus):
		return
	var sound : AudioStreamPlayer = samples[bus]
	if not sound.playing:
		sound.play()
