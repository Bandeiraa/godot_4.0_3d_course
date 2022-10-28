extends NavigationRegion3D
class_name NavigationRegion

@onready var region: RID = NavigationServer3D.region_create()

func _ready() -> void:
	NavigationServer3D.region_set_map(region, get_world_3d().navigation_map)
	NavigationServer3D.region_set_navmesh(region, navmesh)
	bake_navigation_mesh()
