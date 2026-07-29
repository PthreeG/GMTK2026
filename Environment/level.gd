extends Node3D


@onready var label: Label = $FadeToBlack/Label


func _on_area_3d_body_entered(body: Node3D) -> void: ## Endgame circle entery
	if body is Player:
		GameStateController.current_state = GameStateController.STATES.WIN

func _ready() -> void:
	CloseGame.paused_game.connect(on_game_closed)
	#label.hide()

func on_game_closed(tf: bool) -> void:
	if tf:
		label.show()
	else: label.hide()
