extends Node3D
class_name EnemyAnimation

@onready var parent: RigidBody3D = get_parent()
@onready var detection_area: Area3D = get_node("%DetectionArea")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")

var on_action: bool = false

func animate(velocity: Vector3) -> void:
	if on_action:
		return
		
	move_behavior(velocity)
	
	
func action_behavior(action: String) -> void:
	on_action = true
	animation.play(action)
	
	
func move_behavior(velocity: Vector3) -> void:
	if velocity != Vector3.ZERO:
		animation.play(detection_area.move_state)
		return
		
	animation.play("idle")
	
	
func on_animation_finished(anim_name: String) -> void:
	var attack_action: bool = (
		anim_name == "attack_spinning"
	)
	
	if attack_action:
		on_action = false
		parent.freeze = false
		detection_area.is_attacking = false
