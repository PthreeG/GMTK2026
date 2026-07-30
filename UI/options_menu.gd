extends VBoxContainer

@onready var slider_master_volume: HSlider = %"Slider-Master_Volume"
@onready var slider_music_volume: HSlider = %"Slider-Music_Volume"
@onready var slider_sfx_volume: HSlider = %"Slider-SFX_Volume"
@onready var slider_mouse_sensitivity: HSlider = %"Slider-Mouse_Sensitivity"
#@onready var check_box: CheckBox = $HBoxContainer5/CheckBox


func _on_slider_master_volume_drag_ended(_value_changed: bool) -> void:
	Settings.master_volume = slider_master_volume.value


func _on_slider_music_volume_drag_ended(_value_changed: bool) -> void:
	Settings.music_volume = slider_music_volume.value


func _on_slider_sfx_volume_drag_ended(_value_changed: bool) -> void:
	Settings.sfx_volume = slider_sfx_volume.value


func _on_slider_mouse_sensitivity_drag_ended(_value_changed: bool) -> void:
	Settings.mouse_sensitivity = slider_mouse_sensitivity.value


func _on_check_box_toggled(toggled_on: bool) -> void:
	Settings.post_processing_effects = toggled_on
