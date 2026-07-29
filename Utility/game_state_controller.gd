extends Node
class_name game_state_controller

enum STATES 
{
	MAIN_MENU,
	ACTIVE,
	PAUSED,
	LOSS,
	WIN,
}
signal state_changed(new: STATES, previous: STATES)

@export var current_state: STATES = STATES.ACTIVE: set = set_state

func set_state(state: STATES) -> void:
	if state == current_state: return
	else:
		var previous_state := current_state
		current_state = state
		state_changed.emit(current_state, previous_state)

func is_game_paused_or_active() -> bool:
	return true if (current_state == GameStateController.STATES.ACTIVE or current_state == GameStateController.STATES.PAUSED) else false
