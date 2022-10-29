extends Area3D
class_name EnemyHurtbox

@onready var enemy: RigidBody3D = get_parent()

var damage: int = 1

func _ready() -> void:
	randomize()
	damage = randi() % 10 + 1
	
	
func on_body_entered(body) -> void:
	if body.is_in_group("character"):
		body.update_health("decrease", damage, enemy.global_position)
