extends Node
class_name EnemyStateMachine

enum STATES { 
	IDLE,
	PATROLLING,
	PURSUING,
	ATTACKING,
	}

signal state_changed(new: STATES, previous: STATES)

@export var current_state: STATES = STATES.IDLE: set = set_state


func set_state(state: STATES) -> void:
	if state == current_state: return
	else:
		var previous_state := current_state
		current_state = state
		print("Enemy entered state " + STATES.keys()[current_state] + " :: Exited state " + STATES.keys()[previous_state])
		state_changed.emit(current_state, previous_state)


#func on_state_changed(new: EnemyStateMachine.STATES, previous: EnemyStateMachine.STATES) -> void:
	#match new:
		#EnemyStateMachine.STATES.IDLE:
			#pass
		#EnemyStateMachine.STATES.PATROLLING:
			#pass
		#EnemyStateMachine.STATES.PURSUING:
			#pass
		#EnemyStateMachine.STATES.ATTACKING:
			#pass
