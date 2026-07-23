extends RayCast3D

@export var player_points: Array[Node3D]
@export var dot_min: float = 0.5
@onready var timer: Timer = $Timer

signal found_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(check_for_player)

func check_for_player() -> void:
	for point in player_points:
		target_position = point.global_position
		if get_collider() is not Player: return
		var to_player = Vector2((Vector2(target_position.x, target_position.z) - Vector2(global_position.x, global_position.z)).normalized())
		
		var dot = to_player.dot(Vector2.UP)
		if dot > dot_min:
			found_player.emit()
			print("Found player")
			return
	
