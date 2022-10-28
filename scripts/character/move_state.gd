extends Node
class_name CharacterMoveState

@onready var twist_pivot: Node3D = get_node("%TwistPivot")

var previous_input: Vector3

@export var move_force: float = 20.0
@export var sprint_force: float = 50.0

func horizontal_movement(state: PhysicsDirectBodyState3D) -> void:
	var input: Vector3 = get_input()
	if input != Vector3.ZERO:
		previous_input = input
		
	if is_sprinting():
		state.apply_central_force(input * sprint_force)
		return
		
	state.apply_central_force(input * move_force)
	
	
func get_input() -> Vector3:
	var input: Vector3 = Vector3.ZERO
	
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")
	
	input = twist_pivot.global_transform.basis * input.normalized()
	return input
	
	
func is_sprinting() -> bool:
	if Input.is_action_pressed("sprinting"):
		return true
		
	return false
