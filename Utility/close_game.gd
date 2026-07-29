extends Node

signal paused_game(tf: bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	if Input.is_action_just_pressed("quit_game") and GameStateController.current_state == GameStateController.STATES.ACTIVE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			paused_game.emit(true)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			paused_game.emit(false)
