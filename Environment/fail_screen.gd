extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStateController.state_changed.connect(on_game_state_changed)


func on_game_state_changed(current: game_state_controller.STATES, prev: game_state_controller.STATES) -> void:
	match current:
		game_state_controller.STATES.LOSS:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			animation_player.play("fade_to_black")
			mouse_filter = Control.MOUSE_FILTER_STOP
			for child in get_children():
				if child is Control:
					child.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
