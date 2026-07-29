extends Node3D


@onready var label: Label = $UI/Label


func _on_area_3d_body_entered(body: Node3D) -> void: ## Endgame circle entery
	if body is Player:
		GameStateController.current_state = GameStateController.STATES.WIN


func _ready() -> void:
	GameStateController.state_changed.connect(on_game_state_changed)
	#label.hide()


func on_game_state_changed(current: game_state_controller.STATES, _prev: game_state_controller.STATES) -> void:
	match current:
		GameStateController.STATES.MAIN_MENU:
			label.hide()
		
		GameStateController.STATES.ACTIVE:
			label.hide()
		
		GameStateController.STATES.LOSS:
			label.hide()
		
		GameStateController.STATES.WIN:
			label.hide()
		
		GameStateController.STATES.PAUSED:
			label.show()
