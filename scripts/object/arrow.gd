extends Area3D
class_name CharacterArrow

@onready var animation: AnimationPlayer = get_node("Animation")

var is_placed: bool = false

@export var speed: float = 20.0
@export var damage: int = 5

func _physics_process(delta: float) -> void:
	var forward_direction: Vector3 = global_transform.basis.z.normalized()
	global_translate(-forward_direction * speed * delta)
	
	
func on_body_entered(body) -> void:
	if body.is_in_group("enemy"):
		body.update_health(damage, global_position)
		queue_free()
		
		
	if is_placed and body.is_in_group("character"):
		queue_free()
		
	if body.is_in_group("object") and not is_placed:
		body.interact()
		
	if body is GridMap or body is StaticBody3D:
		speed = 0.0
		animation.stop()
		is_placed = true
		
		
func on_timer_timeout() -> void:
	if not is_placed:
		queue_free()
