extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStateController.current_state = game_state_controller.STATES.ACTIVE
