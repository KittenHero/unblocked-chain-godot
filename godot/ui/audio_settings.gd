extends Control

@onready var master_slider: Range = %MasterSlider
@onready var bgm_slider: Range = %BGMSlider
@onready var sfx_slider: Range = %SFXSlider
@onready var slot_slider: Range = %SlotSlider

func _ready() -> void:
	master_slider.value = Settings.master_volume
	bgm_slider.value = Settings.bgm_volume
	sfx_slider.value = Settings.sfx_volume
	slot_slider.value = Settings.slot_volume
	self.visibility_changed.connect(self.grab_focus)

func _on_slot_slider_value_changed(value: float) -> void:
	Settings.slot_volume = value
	Settings.save_data()

func _on_master_slider_value_changed(value: float) -> void:
	Settings.master_volume = value
	Settings.save_data()

func _on_bgm_slider_value_changed(value: float) -> void:
	Settings.bgm_volume = value
	Settings.save_data()

func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.sfx_volume = value
	Settings.save_data()
