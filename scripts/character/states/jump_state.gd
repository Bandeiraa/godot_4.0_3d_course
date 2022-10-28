extends Node
class_name CharacterJumpState

var is_jumping: bool = false
var character: RigidBody3D = null

@export var jump_force: float = 20.0

func jump_handler(body: Node3D, _character: RigidBody3D, is_on_floor: bool) -> void:
	character = _character
	if Input.is_action_just_pressed("ui_select") and not is_jumping and is_on_floor:
		body.action_behavior("jump")
		_character.freeze = true
		is_jumping = true
		
		
func jump() -> void:
	is_jumping = false
	character.freeze = false
	character.apply_central_impulse(Vector3.UP * jump_force)
