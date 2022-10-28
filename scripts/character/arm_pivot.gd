extends Node3D
class_name ArmPivot

@onready var parent: RigidBody3D = get_parent()
@onready var pitch_pivot: Node3D = get_node("PitchPivot")

var twist_input: float
var pitch_input: float

@export var mouse_sensitivity: float = 0.1

@export var twist_speed: float = 0.1
@export var pitch_speed: float = 0.1

@export var lower_limit: float = deg_to_rad(15.0)
@export var upper_limit: float = deg_to_rad(-15.0)

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity
		
		
func update(delta: float) -> void:
	change_origin(delta)
	rotate_camera(delta)
	
	
func change_origin(delta: float) -> void:
	transform.origin = transform.origin.lerp(
		parent.transform.origin, 12.0 * delta
	)
	
	
func rotate_camera(delta: float) -> void:
	rotate_y(twist_input * twist_speed * delta)
	pitch_pivot.rotate_x(pitch_input * pitch_speed * delta)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		upper_limit,
		lower_limit
	)
	
	reset_input()
	
	
func reset_input() -> void:
	twist_input = 0.0
	pitch_input = 0.0
