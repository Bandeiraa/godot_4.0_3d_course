extends Node3D
class_name CharacterAnimation

@onready var state_manager: Node = get_node("%StateManager")
@onready var move_state: Node = state_manager.get_node("Move")

@onready var animation: AnimationPlayer = get_node("Animation")

var on_action: bool = false

func update(input: Vector3, delta: float) -> void:
	align(input, delta)
	animate(input)
	
	
func align(input: Vector3, delta: float) -> void:
	if input == Vector3.ZERO:
		return
		
	var alignment: Transform3D = transform.looking_at(input, Vector3.UP)
	transform = transform.interpolate_with(alignment, delta * 16.0)
	
	
func animate(velocity: Vector3) -> void:
	if on_action:
		return
		
	horizontal_behavior(velocity)
	
	
func action_behavior(action: String) -> void:
	on_action = true
	animation.play(action)
	
	
func horizontal_behavior(velocity: Vector3) -> void:
	if move_state.is_sprinting() and velocity != Vector3.ZERO:
		animation.play("run")
		return
		
	if velocity != Vector3.ZERO:
		animation.play("walk")
		return
		
	animation.play("idle")
	
	
func on_animation_finished(anim_name: String) -> void:
	var attack_action: bool = (
		anim_name == "shoot_bow_2h"
	)
	
	if attack_action:
		on_action = false
		state_manager.is_attacking = false
		
	if anim_name == "jump":
		on_action = false
