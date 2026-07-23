extends Node

var breath: float = 1
var loss_speed: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Input.is_action_pressed("hold_breath"):
		breath -= loss_speed * delta
