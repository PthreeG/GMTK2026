extends Node
class_name BrokenFeet

@onready var player: Player = $".."
@onready var walk_time_slider: VSlider = %WalkTimeSlider

@onready var can_walk_timer: Timer = %CanWalkTimer

@onready var no_walk_timer: Timer = %NoWalkTimer


func _ready() -> void:
	GameStateController.state_changed.connect(on_game_stat_update)
	walk_time_slider.hide()


func _process(_delta: float) -> void:
	if !can_walk_timer.is_stopped() and GameStateController.current_state == GameStateController.STATES.ACTIVE:
		walk_time_slider.value = (can_walk_timer.time_left / can_walk_timer.wait_time) * 100
	elif !no_walk_timer.is_stopped() and GameStateController.current_state == GameStateController.STATES.ACTIVE:
		walk_time_slider.value = 100 - ((no_walk_timer.time_left / no_walk_timer.wait_time) * 100)

func on_game_stat_update(state: GameStateController.STATES, _x) -> void:
	if state == GameStateController.STATES.ACTIVE:
		can_walk_timer.start()
		walk_time_slider.show()
	else:
		can_walk_timer.stop()
		no_walk_timer.stop()


func _on_can_walk_timer_timeout() -> void:
	no_walk_timer.start()
	player.axis_lock_linear_x = true
	player.axis_lock_linear_y = true
	player.axis_lock_linear_z = true


func _on_no_walk_timer_timeout() -> void:
	can_walk_timer.start()
	player.axis_lock_linear_x = false
	player.axis_lock_linear_y = false
	player.axis_lock_linear_z = false
