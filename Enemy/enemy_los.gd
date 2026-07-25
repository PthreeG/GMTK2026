extends Node3D
class_name EnemyLOS

@export var dot_min: float = 0.5
@onready var timer: Timer = $RayCast3D/Timer
@export var ray_cast: RayCast3D 
@onready var area_3d: Area3D = $Area3D

signal found_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#timer.timeout.connect(mesh_instance_3d.clear_lines)

func _physics_process(_delta: float) -> void:
	check_for_player()


func check_for_player() -> void:
	var bodies = area_3d.get_overlapping_bodies()
	for body in bodies:
		if body is not Player: continue
		var target_pos = body.global_position - ray_cast.global_position
		ray_cast.global_rotation_degrees = Vector3(0, 0, 0) #Must be done to keep rotaion
		ray_cast.target_position = target_pos
		var collider = ray_cast.get_collider()
		if collider is not Player: return
		print("Enemy found Player!")
		found_player.emit()
	
	##for point in player_points:
	#ray_cast.target_position = get_tree().get_first_node_in_group("Player").global_position - global_position
	#if ray_cast.get_collider() is not Player: return
	#var to_player = Vector2((Vector2(ray_cast.target_position.x, ray_cast.target_position.z) - Vector2(global_position.x, global_position.z)).normalized())
	#
	#var dot = to_player.dot(Vector2.UP)
	#print(str(dot))
	#if dot > dot_min:
		#found_player.emit()
		#print("Found player")
		#return
	
