extends CharacterBody3D
class_name Enemy

@export var player: Player
@export var active_speed: float = 4.0
@export var patrolling_speed: float = 2.5
@export var pursuing_speed: float = 6
@export var path: Path3D
@export var rotation_speed = 10.0
@export var player_camera_grab_speed: float = 5
var grab_camera: bool = false
@export var patrol_to_player_chance: float = 0.1
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

@onready var camera_look_at: Marker3D = $CameraLookAt
@onready var los: EnemyLOS = $LOS
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var path_finding: EnemyPathFinding = $EnemyPathFinding
@onready var mouth_asp: AudioStreamPlayer3D = $MouthASP

var current_path_index: int = 0

@export var aggresive_click: AudioStream
@export var passive_click: AudioStream
@export var click_chance: float = 0.2

func _ready() -> void:
	on_state_changed(state_machine.current_state, state_machine.current_state)
	GameStateController.state_changed.connect(on_game_state_changed)

func _process(_delta: float) -> void:
	if grab_camera:
		player.camera.look_at(camera_look_at.global_position)
		player.camera.fov = 15
		look_at(player.camera.global_position)
		#var target_transform = player.camera.transform.looking_at(camera_look_at.global_position, Vector3.UP, true)
		#player.camera.global_basis = transform.basis.slerp(target_transform., player_camera_grab_speed * _delta)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state_machine.current_state == EnemyStateMachine.STATES.PURSUING:
		nav_agent.target_position = player.global_position
	
	nav_safe()
	move_and_slide()
	rotate_towards_movement_direction(delta)



func rotate_towards_movement_direction(delta: float):
	var velocity_horizontal = Vector3(velocity.x, 0, velocity.z)
	if velocity_horizontal.length_squared() > 0.01:
		# Calculate the target transform while keeping the character upright
		var target_transform = transform.looking_at(global_position + velocity_horizontal, Vector3.UP)
		# Smoothly interpolate the basis towards the movement direction
		transform.basis = transform.basis.slerp(target_transform.basis, rotation_speed * delta)

func on_target_reached() -> void:
	print("Enemy reached nav target")
	
	if state_machine.current_state == state_machine.STATES.PATROLLING:
	## EnemyPathFinding
		patrol_to_new_locaiton()
	## Path3D based enemy AI
		#current_path_index += 1
		#if current_path_index + 1 > path.curve.point_count:
			#current_path_index = 0
		#nav_agent.target_position = path.curve.get_point_position(current_path_index)
		#print("Updated enemy target position to " + str(path.curve.get_point_position(current_path_index)) + " at index " + str(current_path_index))

func on_state_changed(new: EnemyStateMachine.STATES, _previous: EnemyStateMachine.STATES) -> void:
	match new:
		state_machine.STATES.IDLE: ## Stop navigation and play idle animation
			nav_agent.target_position = global_position
			#animation_player.speed_scale = 1
			animation_player.pause()
			
			nav_agent.target_position = global_position
			los.area_3d.monitoring = false
			
			lock_all_linear_axis(true)
		
		state_machine.STATES.PATROLLING: ## Begin pathing to patrol points and play anim
			patrol_to_new_locaiton()
			active_speed = patrolling_speed
			los.area_3d.monitoring = true
			lock_all_linear_axis(false)
			var t := create_tween().set_parallel()
			t.tween_property(animation_tree, "parameters/AnimationNodeBlendSpace1D/blend_position", 1, 0.5)
			t.tween_property(animation_tree, "parameters/TimeScale/scale", 6, 0.5)
			mouth_asp.stream = passive_click
			
		
		## Increase speed of movement and animation
		## Updating nav pathing to player done in physics_process
		state_machine.STATES.PURSUING: 
			lock_all_linear_axis(false)
			var t := create_tween().set_parallel()
			t.tween_property(animation_tree, "parameters/AnimationNodeBlendSpace1D/blend_position", -1, 0.5)
			t.tween_property(animation_tree, "parameters/TimeScale/scale", 7.5, 0.5)
			los.area_3d.monitoring = true
			active_speed = pursuing_speed
			if mouth_asp.playing == true:
				mouth_asp.stop()
			mouth_asp.stream = aggresive_click
			mouth_asp.play()
			#animation_player.speed_scale = 2
		
		state_machine.STATES.ATTACKING: ## Disable player movement, grab camera, play animation, set game state to LOSS
			lock_all_linear_axis(true)
			
			axis_lock_angular_y = true
			
			## Freeze player movemnt
			player.axis_lock_linear_x = true
			player.axis_lock_linear_y = true
			player.axis_lock_linear_z = true
			player.movement_enabled = false
			
			player.camera.cam_movement_enabled = false
			grab_camera = true
			
			
			#animation_player.play("attack")
			#animation_player.speed_scale = 1
			get_tree().create_timer(1.5).timeout.connect(func(): GameStateController.current_state = GameStateController.STATES.LOSS)
			

func on_game_state_changed(current: game_state_controller.STATES, _prev: game_state_controller.STATES) -> void:
	match current:
		game_state_controller.STATES.MAIN_MENU:
			state_machine.current_state = EnemyStateMachine.STATES.IDLE
			
		
		game_state_controller.STATES.ACTIVE:
			state_machine.current_state = EnemyStateMachine.STATES.PATROLLING
			lock_all_linear_axis(false)
			
		GameStateController.STATES.PAUSED:
			lock_all_linear_axis(true)
		
		game_state_controller.STATES.LOSS:
			## Prevent bug when game ends and enemy keeps pushing player
			lock_all_linear_axis(true)
		GameStateController.STATES.WIN:
			state_machine.current_state = EnemyStateMachine.STATES.IDLE



func nav_safe() -> void:
	if nav_agent.is_navigation_finished(): return
	#print(name + " is naving safe towards player at " + str(player.position))
	var next_path_pos := nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (global_position.direction_to(next_path_pos) * active_speed)
	nav_agent.velocity = new_velocity

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity.normalized() * active_speed


func _on_los_found_player() -> void:
	state_machine.current_state = EnemyStateMachine.STATES.PURSUING
	los.found_player.disconnect(_on_los_found_player)


func _on_player_catch_region_body_entered(body: Node3D) -> void:
	#print("body entered")
	if body is not Player: return
	print("Enemy caught player!")

	
	state_machine.current_state = state_machine.STATES.ATTACKING


func _on_timer_timeout() -> void:
	if state_machine.current_state != state_machine.STATES.PATROLLING: return
	if player.global_position.distance_squared_to(nav_agent.target_position) > path_finding.player_node_range_sqrd:
		patrol_to_new_locaiton()


func patrol_to_new_locaiton() -> void:
	if patrol_to_player_chance > randf():
		nav_agent.target_position = player.global_position
	
	var node = path_finding.get_random_node_from_player_pos()
	nav_agent.target_position = node.global_position

func lock_all_linear_axis(lock: bool) -> void:
	axis_lock_linear_x = lock
	axis_lock_linear_y = lock
	axis_lock_linear_z = lock


func _on_click_timer_timeout() -> void:
	if mouth_asp.playing: return
	if click_chance > randf():
		mouth_asp.play()
