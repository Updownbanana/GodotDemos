extends MeshInstance3D

var height : float
var height_max : float = 5
var height_offset : float
var height_offset_max : float = 6

func _init():
	mesh = BoxMesh.new()
	height = mesh.size.y
	material_override = StandardMaterial3D.new()
	height_offset = randf_range(0, height_offset_max)

func _process(delta):
	mesh.size.y = height
	global_position.y = (mesh.size.y / 2) + 1
	set_color_by_mesh_size()

func set_color_by_height():
	var hue = height * 0.83 / height_max
	material_override.albedo_color = Color.from_hsv(hue, 1.0, 1.0)

func set_color_by_mesh_size():
	var hue = mesh.size.y * 0.83 / (height_max + height_offset_max)
	material_override.albedo_color = Color.from_hsv(hue, 1.0, 1.0)
