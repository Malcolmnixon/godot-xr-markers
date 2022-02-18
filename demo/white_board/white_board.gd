class_name WhiteBoard
extends StaticBody


export var image_width := 1024
export var image_height := 1024
export var initial_color := Color.white

export var plane_width := 0.5
export var plane_height := 0.5

# Node references
onready var _collision : CollisionShape = $WhiteBoardCollision
onready var _mesh : MeshInstance = $WhiteBoardMesh
onready var _viewport : WhiteBoardViewport = $WhiteBoardViewport


func _ready():
	_viewport.clear(initial_color)


func mark(var color: Color, var from: Vector2, var to: Vector2):
	_viewport.mark(color, from, to)


func erase(var from: Vector2, var to: Vector2):
	_viewport.erase(initial_color, from, to)


func to_image(var position: Vector3) -> Vector2:
	# Convert from global to local
	var local_position : Vector3 = global_transform.xform_inv(position)

	# Convert from local to image
	var image_position := Vector2.ZERO
	image_position.x = (local_position.x + plane_width * 0.5) * image_width / plane_width
	image_position.y = (local_position.y + plane_height * 0.5) * image_height / plane_height

	# Return the image position
	return image_position
