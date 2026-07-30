extends CharacterBody3D
class_name Player

@export var speed: float = 5.0
@export var movement_enabled: bool = true
@export var camera: CamController

func _ready() -> void:
	GameStateController.state_changed.connect(on_game_state_changed)

func _physics_process(delta: float) -> void:
	process_movement(delta)


func process_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	if movement_enabled:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func on_game_state_changed(current: game_state_controller.STATES, _prev: game_state_controller.STATES) -> void:
	@warning_ignore("standalone_ternary")
	set_axis_lock_linear_all(false) if current == GameStateController.STATES.ACTIVE else set_axis_lock_linear_all(true)


func set_axis_lock_linear_all(locked: bool) -> void:
	axis_lock_linear_x = locked
	axis_lock_linear_y = locked
	axis_lock_linear_z = locked
