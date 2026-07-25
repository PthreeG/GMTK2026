extends Node
class_name EnemyPathFinding


@export var pathing_nodes: Array[Marker3D]
@export var default_pathing_node: Node3D
var visited_node_history: Array[Node3D]
@export var node_history_max_size: int = 3

@export var player_node_range: float = 50:
	set(v):
		player_node_range_sqrd = pow(v, 2)
		player_node_range = v
var player_node_range_sqrd

var player: Player : 
	get:
		if player == null: player = get_tree().get_first_node_in_group("Player")
		return player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player_node_range_sqrd = pow(player_node_range, 2)
	for child in get_children():
		if child is Node3D:
			pathing_nodes.append(child)


## Returns a random node that is a range from the players position.
## Will not return previously visited nodes going
func get_random_node_from_player_pos() -> Node3D:
	var nodes_in_range: Array[Node3D]
	for node in pathing_nodes:
		if player.global_position.distance_squared_to(node.global_position) <= player_node_range_sqrd:
			nodes_in_range.append(node)
	
	## Below cannot be done due to godot not supporting removal of array values while itterating over them
	#nodes_in_range.filter(func(x): if visited_node_history.has(x): nodes_in_range.erase(x))
	
	var valid_nodes_in_range: Array[Node3D]
	for node in nodes_in_range:
		if visited_node_history.has(node): continue
		valid_nodes_in_range.append(node)
	
	if valid_nodes_in_range.size() == 0: 
		push_warning("Enemy failed to find valid node to path to, returning default node.")
		return default_pathing_node
	else: 
		var ret: Node3D = valid_nodes_in_range.pick_random()
		append_node_visited_history(ret)
		print("Enemy pathing to node at " + str(ret.global_position))
		return ret


func append_node_visited_history(added_node: Node3D) -> void:
	while visited_node_history.size() >= node_history_max_size:
		visited_node_history.pop_front()
	visited_node_history.append(added_node)
	print("Added node to visited history")
