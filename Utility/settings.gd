extends Node
class_name settings

signal master_volume_set(val: float)
signal music_volume_set(val: float)
signal sfx_volume_set(val: float)
signal mouse_sensitivity_set(val: float)
signal post_processing_effects_set(val: bool)


var master_volume: float = 1 : set = set_master_volume
var music_volume: float = 1 : set = set_music_volume
var sfx_volume: float = 1 : set = set_sfx_volume
var mouse_sensitivity: float = 1 : set = set_mouse_sensitivity
var post_processing_effects: bool = true : set = set_post_processing_effects


func set_master_volume(val: float) -> void:
	val = clamp(val, 0, 1)
	master_volume = val
	master_volume_set.emit(master_volume)

func set_music_volume(val: float) -> void:
	val = clamp(val, 0, 1)
	music_volume = val
	music_volume_set.emit(music_volume)

func set_sfx_volume(val: float) -> void:
	val = clamp(val, 0, 1)
	sfx_volume = val
	sfx_volume_set.emit(sfx_volume)

func set_mouse_sensitivity(val: float) -> void:
	val = clamp(val, 0, 2)
	mouse_sensitivity = val
	mouse_sensitivity_set.emit(mouse_sensitivity)

func set_post_processing_effects(val: bool) -> void:
	post_processing_effects = val
	post_processing_effects_set.emit(post_processing_effects)
