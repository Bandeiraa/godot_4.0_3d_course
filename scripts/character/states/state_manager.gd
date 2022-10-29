extends Node
class_name CharacterStateManager

@onready var body: Node3D = get_node("%Body")
@onready var character: RigidBody3D = get_parent()
@onready var knockback_timer: Timer = get_node("Knockback/KnockbackTimer")

@onready var move_state: Node = get_node("Move")
@onready var jump_state: Node = get_node("Jump")
@onready var attack_state: Node = get_node("Attack")
@onready var knockback_state: Node = get_node("Knockback")

var is_attacking: bool = false
var on_knockback: bool = false
var knockback_direction: Vector3 = Vector3.ZERO

func update(state: PhysicsDirectBodyState3D) -> void:
	if on_knockback:
		knockback_state.horizontal_movement(knockback_direction, state)
		return
		
	move_state.horizontal_movement(state)
	
	if not body.on_action:
		jump_state.jump_handler(
			body, 
			character,
			character.is_on_floor()
		)
		
		attack_state.attack_handler(
			is_attacking, 
			character.is_on_floor(), 
			body, 
			character
		)
		
		
func initialize_knockback_timer(length: float, direction: Vector3) -> void:
	knockback_direction = direction
	
	if knockback_direction == Vector3.ZERO:
		knockback_direction = move_state.previous_input
		
	knockback_timer.start(length)
	character.freeze = false
	on_knockback = true
	
	
func on_knockback_timer_timeout() -> void:
	on_knockback = false
