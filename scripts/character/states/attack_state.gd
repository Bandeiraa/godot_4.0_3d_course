extends Node
class_name CharacterAttackState

const ARROW: PackedScene = preload("res://scenes/object/arrow.tscn")

@onready var state_manager: Node = get_parent()
@onready var attack_spawner: Marker3D = get_node("%AttackSpawner")

func attack_handler(
	is_attacking: bool, 
	is_on_floor: bool, 
	body: Node3D, 
	character: RigidBody3D
	) -> void:
		
	if Input.is_action_just_pressed("ui_attack") and not is_attacking and is_on_floor:
		body.action_behavior("shoot_bow_2h")
		character.freeze = true
		state_manager.is_attacking = true
		
		
func shoot() -> void:
	state_manager.initialize_knockback_timer(0.1, Vector3.ZERO)
	
	var arrow = ARROW.instantiate()
	get_tree().root.call_deferred("add_child", arrow)
	arrow.global_transform = attack_spawner.global_transform
