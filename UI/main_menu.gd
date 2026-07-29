extends Control

@export var level_scene: PackedScene
@onready var tab_container: TabContainer = $TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStateController.current_state = GameStateController.STATES.MAIN_MENU


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_start_pressed() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameStateController.current_state = GameStateController.STATES.ACTIVE


func _on_button_options_pressed() -> void:
	tab_container.current_tab = 1


func _on_button_credits_pressed() -> void:
	pass # Replace with function body.


func _on_button_option_back_pressed() -> void:
	tab_container.current_tab = 0
