tool
class_name WhiteBoard
extends StaticBody


## Property for underlying whiteboard image size
export var image_size: Vector2 setget _set_image_size, _get_image_size

## Scale to convert image to world coordinates
export (float, 0.0000, 0.0100, 0.0001) var image_scale: float setget _set_image_scale, _get_image_scale

## Initial whiteboard color
export var initial_color: Color setget _set_initial_color, _get_initial_color


# Private fields
var _is_ready := false
var _image_size := Vector2(1000.0, 1000.0)
var _image_scale := 0.0005
var _initial_color := Color.white

# Node references
onready var _collision: CollisionShape = $WhiteBoardCollision
onready var _mesh: MeshInstance = $WhiteBoardMesh
onready var _viewport: WhiteBoardViewport = $WhiteBoardViewport


func _ready():
	_is_ready = true
	_update_whiteboard_geometry()


# Mark an area of the white-board
func mark(var from: Vector2, var to: Vector2, var color: Color, var width: float):
	_viewport.mark(from, to, color, width / _image_scale)


# Erase an area of the white-board
func erase(var from: Vector2, var to: Vector2, var width: float):
	_viewport.erase(from, to, _initial_color, width / _image_scale)


# Convert world-coordinates to image coordinates
func to_image(var position: Vector3) -> Vector2:
	# Convert from global to local
	var local_position : Vector3 = global_transform.xform_inv(position)

	# Convert from local to image
	var image_position := Vector2(local_position.x, local_position.y)
	image_position /= _image_scale;
	image_position += _image_size * 0.5

	# Return the image position
	return image_position


# Update the white-board geometry
func _update_whiteboard_geometry():
	# Skip if not ready
	if !_is_ready:
		return

	# Set the viewport size
	_viewport.size = _image_size
	_viewport.clear(_initial_color)

	# Update the box shape
	var shape := _collision.shape as BoxShape
	if shape:
		shape.extents = Vector3(
				_image_size.x * _image_scale * 0.5,
				_image_size.y * _image_scale * 0.5,
				0.001)

	# Update the mesh shape
	var mesh := _mesh.mesh as QuadMesh
	if mesh:
		mesh.size = _image_size * _image_scale


func _set_image_size(var value: Vector2):
	_image_size = value
	_update_whiteboard_geometry()


func _get_image_size() -> Vector2:
	return _image_size


func _set_image_scale(var value: float):
	_image_scale = value
	_update_whiteboard_geometry()


func _get_image_scale() -> float:
	return _image_scale


func _set_initial_color(var value: Color):
	_initial_color = value
	_update_whiteboard_geometry()


func _get_initial_color() -> Color:
	return _initial_color
