extends CharacterBody3D
class_name Enemy

@export var player: Node3D
@export var speed: float = 4.0
@export var path: Path3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

var current_path_index: int = 0


func _ready() -> void:
	on_state_changed(state_machine.current_state, state_machine.current_state)

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state_machine.current_state == EnemyStateMachine.STATES.PURSUING:
		nav_agent.target_position = player.global_position
	
	nav_safe()
	move_and_slide()

func on_target_reached() -> void:
	print("Enemy reached nav target")
	if state_machine.current_state == state_machine.STATES.PATROLLING:
		current_path_index += 1
		if current_path_index + 1 > path.curve.point_count:
			current_path_index = 0
		nav_agent.target_position = path.curve.get_point_position(current_path_index)
		print("Updated enemy target position to " + str(path.curve.get_point_position(current_path_index)) + " at index " + str(current_path_index))

func on_state_changed(new: EnemyStateMachine.STATES, previous: EnemyStateMachine.STATES) -> void:
	print("state updated")
	match new:
		state_machine.STATES.IDLE:
			pass
		state_machine.STATES.PATROLLING:
			nav_agent.target_position = path.curve.get_point_position(current_path_index)
		state_machine.STATES.PURSUING:
			pass
		state_machine.STATES.ATTACKING:
			pass


func nav_safe() -> void:
	if nav_agent.is_navigation_finished(): return
	#print(name + " is naving safe towards player at " + str(player.position))
	var next_path_pos := nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (global_position.direction_to(next_path_pos) * speed)
	nav_agent.velocity = new_velocity

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity.normalized() * speed
