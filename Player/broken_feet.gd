extends Node
class_name BrokenFeet

@onready var player: Player = $".."
@onready var walk_time_slider: VSlider = %WalkTimeSlider

@onready var can_walk_timer: Timer = %CanWalkTimer

@onready var no_walk_timer: Timer = %NoWalkTimer

var can_walk: bool = true
#var time_paused_at: float

func _ready() -> void:
	GameStateController.state_changed.connect(on_game_stat_update)
	walk_time_slider.hide()


func _process(_delta: float) -> void:
	if !can_walk_timer.is_stopped() and GameStateController.current_state == GameStateController.STATES.ACTIVE:
		walk_time_slider.value = (can_walk_timer.time_left / can_walk_timer.wait_time) * walk_time_slider.max_value
	elif !no_walk_timer.is_stopped() and GameStateController.current_state == GameStateController.STATES.ACTIVE:
		walk_time_slider.value = 100 - ((no_walk_timer.time_left / no_walk_timer.wait_time) * walk_time_slider.max_value)

func on_game_stat_update(state: GameStateController.STATES, prev: GameStateController.STATES) -> void:
	if state == GameStateController.STATES.ACTIVE and prev == GameStateController.STATES.MAIN_MENU:
		_on_no_walk_timer_timeout()
		no_walk_timer.stop()
		walk_time_slider.show()
	
	elif state == GameStateController.STATES.ACTIVE and prev == GameStateController.STATES.PAUSED:
		can_walk_timer.paused = false
		no_walk_timer.paused = false
	
	elif state == GameStateController.STATES.PAUSED and prev == GameStateController.STATES.ACTIVE:
		can_walk_timer.paused = true
		no_walk_timer.paused = true
	
	elif state == GameStateController.STATES.MAIN_MENU or state == GameStateController.STATES.LOSS or state == GameStateController.STATES.WIN:
		walk_time_slider.hide()
		can_walk_timer.stop()
		no_walk_timer.stop()


func _on_can_walk_timer_timeout() -> void:
	can_walk = false
	no_walk_timer.start()
	player.axis_lock_linear_x = true
	player.axis_lock_linear_y = true
	player.axis_lock_linear_z = true


func _on_no_walk_timer_timeout() -> void:
	can_walk = true
	can_walk_timer.start()
	player.axis_lock_linear_x = false
	player.axis_lock_linear_y = false
	player.axis_lock_linear_z = false
