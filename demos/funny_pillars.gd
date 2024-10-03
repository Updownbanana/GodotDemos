extends Node3D

const PILLAR = preload("res://pillar.tscn")
@onready var light = $OmniLight3D

var gridSizePillars: Vector3 = Vector3(20,0,20)
var gridSizeReal: Vector3
var pillarList = []
var cursorPosMapped: Vector3 = Vector3()
var maxDistance: float

func _ready():
	randomize()
	setup_grid()
	position_camera()
	position_light()

func _process(_delta):
	map_cursor_pos()
	for i in pillarList:
		set_pillar_height_by_cursor(i)
#	move_light()


func setup_grid():
	var referencePillar = PILLAR.instantiate()
	var pillarSize: Vector3 = Vector3(referencePillar.mesh.size.x, 0, referencePillar.mesh.size.z)
	referencePillar.queue_free()
	
	var pillarPlacement: Vector3 = Vector3()
	
	for i in range(0, gridSizePillars.z):
		for j in range(0, gridSizePillars.x):
			var newPillar = PILLAR.instantiate()
			add_child(newPillar)
			newPillar.global_position = pillarPlacement
			pillarList.append(newPillar)
			pillarPlacement.x += pillarSize.x
			newPillar.height = randf_range(1, 2)
		pillarPlacement.x = 0
		pillarPlacement.z += pillarSize.z
		
	gridSizeReal = Vector3(pillarSize.x * gridSizePillars.x, 0, pillarSize.z * gridSizePillars.z)
	maxDistance = max(gridSizeReal.x, gridSizeReal.z)


func position_light():
	light.global_position.y = pillarList[0].height_max + pillarList[0].height_offset_max + 1
	light.omni_range = max(gridSizeReal.x, gridSizeReal.z)
	light.global_position.x = gridSizeReal.x / 2
	light.global_position.z = gridSizeReal.z / 2
	pass


func position_camera():
	var cam_x = gridSizeReal.x * 0.80
	var cam_z = gridSizeReal.z * 1.1
	var cam_y = max((sqrt(cam_x + cam_z) * 1.5), (pillarList[0].height_max + pillarList[0].height_offset_max) * 1.5)
	var center_x = gridSizeReal.x / 2
	var center_z = 0
	$Camera3D.global_position = Vector3(cam_x, cam_y, cam_z)
	$Camera3D.look_at(Vector3(center_x, 0, center_z))


func map_cursor_pos():
	var cursorPosReal = get_viewport().get_mouse_position()
	var viewportSize = get_viewport().get_visible_rect().size
	cursorPosMapped.x = gridSizeReal.x * cursorPosReal.x / viewportSize.x
	cursorPosMapped.z = gridSizeReal.z * cursorPosReal.y / viewportSize.y


func move_light():
	light.global_position.x = cursorPosMapped.x
	light.global_position.z = cursorPosMapped.z


func set_pillar_height_by_cursor(pillar):
	var pillar_pos_grounded = pillar.global_position
	pillar_pos_grounded.y = 0
	var distance = cursorPosMapped.distance_to(pillar_pos_grounded)
	distance = clamp(distance, 0, maxDistance)
	pillar.height = (maxDistance - distance) * (pillar.height_max + pillar.height_offset) / maxDistance
