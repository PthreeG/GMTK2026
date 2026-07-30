# Camera script that requires no additional Node3D anchor/pivots.
# All rotations are interpolated in the process function,
# resulting in smooth motion no matter the physics tickrate.
# Uses quaternions to avoid gimbal lock.

# From u/Dreemlan on reddit https://www.reddit.com/r/godot/comments/1oraj8w/how_to_set_up_a_smooth_first_person_cameraplayer/

extends Camera3D
class_name CamController

@export var player_character_body: CharacterBody3D
var height #height relative to players feet. set on ready
@export var cam_movement_enabled: bool = true
const SENSITIVITY: float = 0.1

var twist_input: float = 0.0
var pitch_input: float = 0.0
var POST_PROCESSING = preload("uid://td583btmoetb")
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	height = position.y
	Settings.post_processing_effects_set.connect(_on_settings_post_processing_set)
	rotation_degrees.y = player_character_body.rotation_degrees.y
	mesh_instance_3d.show()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED and cam_movement_enabled:
		twist_input -= event.screen_relative.x * SENSITIVITY * Settings.mouse_sensitivity
		pitch_input -= event.screen_relative.y * SENSITIVITY * Settings.mouse_sensitivity
		pitch_input = clamp(pitch_input, -85, 85)


func _physics_process(delta: float) -> void:
	if !cam_movement_enabled: return
	var current_q = basis.get_rotation_quaternion()
	var twist_q = Quaternion(Vector3.UP, deg_to_rad(twist_input))
	var pitch_q = Quaternion(Vector3.RIGHT, deg_to_rad(pitch_input))
	var smoothed_q = current_q.slerp(twist_q * pitch_q, delta * 20.0)
	basis = Basis(smoothed_q)
	player_character_body.rotation_degrees.y = rotation_degrees.y
	position = Vector3(player_character_body.position.x, height, player_character_body.position.z)

func _on_settings_post_processing_set(on: bool) -> void:
	POST_PROCESSING.set_shader_parameter("disable_dither", !on)
