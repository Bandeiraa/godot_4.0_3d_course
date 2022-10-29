extends RigidBody3D
class_name CharacterTemplate

@onready var state_manager: Node = get_node("StateManager")
@onready var move_state: Node = get_node("StateManager/Move")

@onready var body: Node3D = get_node("Body")
@onready var floor_ray: RayCast3D = get_node("FloorRay")
@onready var twist_pivot: Node3D = get_node("TwistPivot")

var max_heath: int = 0

var is_node_reparent: bool = false

@export var health: int = 10

func _ready() -> void:
	max_heath = health
	
	
func _physics_process(delta: float) -> void:
	if is_node_reparent:
		return
		
	var input: Vector3 = move_state.get_input()
	
	twist_pivot.update(delta)
	body.update(input, delta, is_on_floor())
	dead_by_height()
	
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state_manager.update(state)
	
	
func is_on_floor() -> bool:
	if floor_ray.is_colliding():
		return true
		
	return false
	
	
func dead_by_height() -> void:
	if position.y < -4.0 and not is_node_reparent:
		is_node_reparent = true
		var child = twist_pivot
		remove_child(twist_pivot)
		get_tree().root.add_child(child)
		
		
func update_health(type: String, value: int, enemy_position: Vector3) -> void:
	if type == "decrease":
		health -= value
		var direction: Vector3 = global_position.direction_to(enemy_position)
		state_manager.initialize_knockback_timer(0.1, direction)
		
	if type == "increase":
		health += value
		
	health = clamp(health, 0, max_heath)
