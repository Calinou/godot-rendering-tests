@tool
extends WorldEnvironment


func _ready() -> void:
	for x in 11:
		for z in 11:
			var mi = MeshInstance3D.new()
			mi.position = Vector3(10 - x * 2, 0, 10 - z * 2)
			mi.mesh = SphereMesh.new()
			var material = StandardMaterial3D.new()
			material.distance_fade_mode = StandardMaterial3D.DISTANCE_FADE_OBJECT_DITHER
			material.distance_fade_min_distance = 5
			material.distance_fade_max_distance = 15
			mi.set_surface_override_material(0, material)
			add_child(mi)
