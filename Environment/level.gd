extends Node3D


@export var pause_menu: Control
@export var roof: Node3D

func _on_area_3d_body_entered(body: Node3D) -> void: ## Endgame circle entery
	if body is Player:
		GameStateController.current_state = GameStateController.STATES.WIN


func _ready() -> void:
	GameStateController.state_changed.connect(on_game_state_changed)
	#pause_menu.hide()
	roof.show()


func on_game_state_changed(current: game_state_controller.STATES, _prev: game_state_controller.STATES) -> void:
	match current:
		GameStateController.STATES.MAIN_MENU:
			pause_menu.hide()
		
		GameStateController.STATES.ACTIVE:
			pause_menu.hide()
		
		GameStateController.STATES.LOSS:
			pause_menu.hide()
		
		GameStateController.STATES.WIN:
			pause_menu.hide()
		
		GameStateController.STATES.PAUSED:
			pause_menu.show()
