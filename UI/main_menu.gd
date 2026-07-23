extends Control

@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(level_scene)


func _on_button_options_pressed() -> void:
	pass # Replace with function body.


func _on_button_credits_pressed() -> void:
	pass # Replace with function body.
