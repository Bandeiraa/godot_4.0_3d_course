extends Node3D
class_name InteractableGrass

@onready var grass_multimesh: MultiMeshInstance3D = get_node("GrassA")

func on_body_entered(body) -> void:
	if body.is_in_group("character") or body.is_in_group("enemy"):
		var tween = create_tween()
		tween.tween_method(
			move_grass,
			0.0,
			1.0,
			0.3
		)
		
		
func move_grass(length: float) -> void:
	grass_multimesh.material_override.set_shader_parameter("emission_energy", lerp(
		1.0, 0.0, length
	))
	
	grass_multimesh.material_override.set_shader_parameter("shake_magnitude", lerp(
		1.0, 0.4, length
	))
	
	grass_multimesh.scale = (Vector3.ONE * 1.3).lerp(
		Vector3.ONE, length
	)
