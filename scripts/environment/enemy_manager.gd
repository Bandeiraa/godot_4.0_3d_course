extends Node3D
class_name EnemyManager

signal target_moved(target_position)

@export var path_to_player: NodePath
@onready var target: RigidBody3D = get_node(path_to_player)
@onready var target_position = target.global_transform.origin

func _ready() -> void:
	for enemy in get_children():
		target_moved.connect(enemy.update_target_position)
		
	target_position = target.global_transform.origin
	emit_signal("target_moved", target_position)
	
	
func _physics_process(_delta: float) -> void:
	if target_position.distance_squared_to(target.global_transform.origin) > 1.0:
		target_position = target.global_transform.origin
		emit_signal("target_moved", target_position)
