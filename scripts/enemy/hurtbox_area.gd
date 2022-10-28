extends Area3D
class_name EnemyHurtbox

var damage: int = 1

func _ready() -> void:
	randomize()
	damage = randi() % 10 + 1
	
	
func on_body_entered(body) -> void:
	if body.is_in_group("character"):
		body.update_health("decrease", damage)
