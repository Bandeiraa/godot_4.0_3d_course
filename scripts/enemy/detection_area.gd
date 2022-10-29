extends Area3D
class_name EnemyDetectionArea

@onready var _body: Node3D = get_node("%Body")
@onready var enemy: RigidBody3D = get_parent()

var player_ref: RigidBody3D = null
var move_state: String = "walk"
var is_attacking: bool = false

func get_speed() -> float:
	if player_ref == null:
		return 0.0
		
	var distance: float = global_transform.origin.distance_to(
		player_ref.global_transform.origin
	)
	
	if distance <= 1.5 and not is_attacking:
		is_attacking = true
		enemy.freeze = true
		_body.action_behavior("attack_spinning")
		return 0.0
		
	if distance >= 12.0:
		move_state = "walk"
		return 1.5
		
	move_state = "run"
	return 2.0
	
	
func on_body_entered(body) -> void:
	if body.is_in_group("character"):
		player_ref = body
		
		
func on_body_exited(body) -> void:
	if body.is_in_group("character"):
		player_ref = null
