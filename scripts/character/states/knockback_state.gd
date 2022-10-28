extends Node
class_name CharacterKnockbackState

@export var knockback_force: float = 120.0

func horizontal_movement(input: Vector3, state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(-input * knockback_force)
