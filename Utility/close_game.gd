extends Node

#signal paused_game(tf: bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	if Input.is_action_just_pressed("quit_game") and GameStateController.is_game_paused_or_active():
		if GameStateController.current_state == GameStateController.STATES.ACTIVE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GameStateController.current_state = GameStateController.STATES.PAUSED
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			GameStateController.current_state = GameStateController.STATES.ACTIVE
