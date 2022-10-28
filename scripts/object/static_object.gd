extends StaticBody3D
class_name StaticObject

@onready var animation: AnimationPlayer = get_node("Animation")

func interact() -> void:
	animation.play("squash_and_stretch")
