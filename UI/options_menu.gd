extends VBoxContainer

@onready var slider_master_volume: HSlider = %"Slider-Master_Volume"
@onready var slider_music_volume: HSlider = %"Slider-Music_Volume"
@onready var slider_sfx_volume: HSlider = %"Slider-SFX_Volume"
@onready var slider_mouse_sensitivity: HSlider = %"Slider-Mouse_Sensitivity"
@onready var check_box: CheckBox = $HBoxContainer5/CheckBox


func _on_slider_master_volume_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var val: float = slider_master_volume.value / slider_master_volume.max_value
		Settings.master_volume = val


func _on_slider_music_volume_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var val: float = slider_music_volume.value / slider_music_volume.max_value
		Settings.music_volume = val


func _on_slider_sfx_volume_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var val: float = slider_master_volume.value / slider_master_volume.max_value
		Settings.sfx_volume = val


func _on_slider_mouse_sensitivity_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var val: float = slider_mouse_sensitivity.value / slider_mouse_sensitivity.max_value
		val *= 2 ## Max mouse sensitivity is 2
		Settings.mouse_sensitivity = val


func _on_check_box_toggled(toggled_on: bool) -> void:
	Settings.post_processing_effects = toggled_on
