extends Node3D
class_name CharacterAnimation

@onready var character: RigidBody3D = get_parent()
@onready var animation: AnimationPlayer = get_node("Animation")

var on_action: bool = false

func animate(velocity: Vector3) -> void:
	if on_action:
		return
		
	horizontal_behavior(velocity)
	
	
func action_behavior(action: String) -> void:
	on_action = true
	animation.play(action)
	
	
func horizontal_behavior(velocity: Vector3) -> void:
	if character.is_sprinting() and velocity != Vector3.ZERO:
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
		character.is_attacking = false
		
	if anim_name == "jump":
		on_action = false
		character.is_jumping = false
