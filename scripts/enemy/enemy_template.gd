extends RigidBody3D
class_name EnemyTemplate

@onready var knockback_timer: Timer = get_node("KnockbackTimer")

@onready var body: Node3D = get_node("Body")
@onready var detection_area: Area3D = get_node("DetectionArea")
@onready var collision: CollisionShape3D = get_node("Collision")
@onready var agent: NavigationAgent3D = get_node("NavigationAgent")

@onready var target_position = global_transform.origin

var max_health: int

var is_dead: bool = false
var on_knockback: bool = false

var knockback_direction: Vector3 = Vector3.ZERO

@export var health: int = 10
@export var knockback_force: float = 60.0

func _ready() -> void:
	max_health = health
	
	NavigationServer3D.agent_set_map(
		agent.get_rid(),
		get_world_3d().navigation_map
	)
	
	agent.set_target_location(target_position)
	
	
func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	if on_knockback and not detection_area.is_attacking:
		align_body(knockback_direction, delta)
		apply_central_force(-knockback_direction * knockback_force)
		return
		
	if detection_area.player_ref == null or detection_area.is_attacking:
		body.animate(Vector3.ZERO)
		return
		
	var new_velocity: Vector3 = move()
	align_body(new_velocity, delta)
	body.animate(new_velocity)
	
	
func move() -> Vector3:
	var current_position: Vector3 = global_transform.origin
	var next_path_position: Vector3 = agent.get_next_location()
	var new_velocity: Vector3 = (next_path_position - current_position).normalized() * detection_area.get_speed()
	
	agent.set_velocity(new_velocity)
	return new_velocity
	
	
func update_target_position(_target_position: Vector3) -> void:
	target_position = _target_position
	agent.set_target_location(target_position)
	
	
func on_velocity_computed(safe_velocity: Vector3) -> void:
	apply_central_force(safe_velocity * detection_area.get_speed())
	
	
func align_body(direction: Vector3, delta: float) -> void:
	if direction.is_equal_approx(Vector3.ZERO) or direction.is_equal_approx(Vector3.UP):
		return
		
	var alignment: Transform3D = body.transform.looking_at(direction, Vector3.UP)
	body.transform = body.transform.interpolate_with(alignment, delta * 16.0)
	body.rotation.x = 0.0
	
	
func update_health(damage: int, attack_position: Vector3) -> void:
	if is_dead:
		return
		
	on_knockback = true
	knockback_timer.start(0.1)
	knockback_direction = (global_position.direction_to(attack_position)).normalized()
	knockback_direction.y = 0
	
	health -= damage
	health = clamp(health, 0, max_health)
	
	if health == 0:
		freeze = true
		is_dead = true
		body.action_behavior("defeat")
		collision.call_deferred("set_disabled", true)
		
		
func on_knockback_timer_timeout() -> void:
	on_knockback = false
