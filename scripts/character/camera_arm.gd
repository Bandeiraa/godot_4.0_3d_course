extends SpringArm3D
class_name CameraArm

@export var zoom_step: float = 0.4

func _unhandled_input(event) -> void:
	if not event is InputEventMouseButton:
		return
		
	if event.button_index == 4:
		spring_length -= zoom_step
		
	if event.button_index == 5:
		spring_length += zoom_step
		
	spring_length = clamp(spring_length, 5.0, 12.0)
