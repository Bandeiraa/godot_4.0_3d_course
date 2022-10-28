extends RigidBody3D
class_name CharacterTemplate

const ARROW: PackedScene = preload("res://scenes/object/arrow.tscn")

@onready var attack_spawner: Marker3D = get_node("Body/AttackSpawner")
@onready var knockback_timer: Timer = get_node("KnockbackTimer")

@onready var body: Node3D = get_node("Body")
@onready var twist_pivot: Node3D = get_node("TwistPivot")
@onready var pitch_pivot: Node3D = get_node("TwistPivot/PitchPivot")
@onready var body_container: BoneAttachment3D = get_node("Body/AnimatedCharacter/Skeleton/Body")

@onready var floor_ray: RayCast3D = get_node("FloorRay")

var previous_input: Vector3

var is_jumping: bool = false
var on_knockback: bool = false
var is_attacking: bool = false
var is_node_reparent: bool = false

var twist_input: float
var pitch_input: float

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var mouse_sensitivity: float = 0.1
@export var twist_speed: float = 0.1
@export var pitch_speed: float = 0.1

@export var jump_speed: float = 20.0
@export var move_speed: float = 20.0
@export var sprint_speed: float = 50.0

@export var lower_limit: float = deg_to_rad(15.0)
@export var upper_limit: float = deg_to_rad(-15.0)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _physics_process(delta: float) -> void:
	if is_node_reparent:
		return
		
	twist_pivot.transform.origin = twist_pivot.transform.origin.lerp(
		transform.origin, 12.0 * delta
	)
	
	
func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity
		
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var input: Vector3 = get_input()
	horizontal_movement(state, input)
	
	if not body.on_action: 
		vertical_movement()
		attack()
		
	rotate_camera(state)
	body.animate(input)
	dead_by_height()
	reset_input()
	
	
func get_input() -> Vector3:
	var input: Vector3 = Vector3.ZERO
	
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")
	
	input = twist_pivot.global_transform.basis * input
	return input
	
	
func horizontal_movement(state: PhysicsDirectBodyState3D, input: Vector3) -> void:
	if is_node_reparent:
		return
		
	if on_knockback:
		state.apply_central_force(-previous_input * move_speed * 6)
		return
		
	if is_sprinting():
		state.apply_central_force(input * sprint_speed)
		
	if not is_sprinting():
		state.apply_central_force(input * move_speed)
		
	if input != Vector3.ZERO:
		previous_input = input
		align_body_with_input(input, state.step)
		
		if not is_on_floor():
			change_particles_state(false)
			return
			
		change_particles_state(is_sprinting())
		
		
func align_body_with_input(input: Vector3, delta: float) -> void:
	var alignment: Transform3D = body.transform.looking_at(input, Vector3.UP)
	body.transform = body.transform.interpolate_with(alignment, delta * 16.0)
	
	
func is_sprinting() -> bool:
	if Input.is_action_pressed("sprinting"):
		return true
		
	return false
	
	
func change_particles_state(state: bool) -> void:
	for children in body_container.get_children():
		if children is GPUParticles3D:
			children.emitting = state
				
				
func vertical_movement() -> void:
	if Input.is_action_just_pressed("ui_select") and not is_jumping and is_on_floor():
		body.action_behavior("jump")
		is_jumping = true
		freeze = true
		
		
func jump() -> void:
	freeze = false
	apply_central_impulse(Vector3.UP * jump_speed)
	
	
func is_on_floor() -> bool:
	if floor_ray.is_colliding():
		return true
		
	return false
	
	
func attack() -> void:
	if Input.is_action_just_pressed("ui_attack") and not is_attacking and is_on_floor():
		body.action_behavior("shoot_bow_2h")
		is_attacking = true
		freeze = true
		
		
func shoot() -> void:
	knockback_timer.start(0.1)
	on_knockback = true
	freeze = false
	
	var arrow = ARROW.instantiate()
	get_tree().root.call_deferred("add_child", arrow)
	arrow.global_transform = attack_spawner.global_transform
	
	
func rotate_camera(state: PhysicsDirectBodyState3D) -> void:
	if is_node_reparent:
		return
		
	twist_pivot.rotate_y(twist_input * twist_speed * state.step)
	pitch_pivot.rotate_x(pitch_input * pitch_speed * state.step)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		upper_limit,
		lower_limit
	)
	
	
func dead_by_height() -> void:
	if position.y < -4.0 and not is_node_reparent:
		is_node_reparent = true
		var child = twist_pivot
		remove_child(twist_pivot)
		get_tree().root.add_child(child)
		
		
func reset_input() -> void:
	twist_input = 0.0
	pitch_input = 0.0
	
	
func on_knockback_timer_timeout() -> void:
	on_knockback = false
