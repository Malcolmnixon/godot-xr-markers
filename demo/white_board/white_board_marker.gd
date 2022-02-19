class_name WhiteBoardMarker
extends XRToolsPickable


## Marker draw-radius
export var draw_radius := 0.003

## Marker tip color
export var tip_color : Color = Color.red


# Private fields
var _is_drag := false
var _last_point := Vector2.ZERO

# Node references
onready var _tip_mesh :MeshInstance = $TipMesh
onready var _tip_ray_cast :RayCast = $TipRayCast


func _ready():
	# Set the tip material
	var tip_material := SpatialMaterial.new()
	tip_material.albedo_color = tip_color
	_tip_mesh.material_override = tip_material


func _process(var _delta: float):
	# Skip if not colliding
	if !_tip_ray_cast.is_colliding():
		_is_drag = false
		return

	# Skip if not colliding a white-board
	var white_board := _tip_ray_cast.get_collider() as WhiteBoard
	if !white_board:
		_is_drag = false
		return

	# Get the white-board point
	var collision_point := _tip_ray_cast.get_collision_point()
	var image_point := white_board.to_image(collision_point)

	# If dragging, mark the white-board
	if _is_drag:
		white_board.mark(_last_point, image_point, tip_color, draw_radius)

	# Update the marker data
	_is_drag = true
	_last_point = image_point


func pick_up(by, with_controller):
	# Call base
	.pick_up(by, with_controller)

	# Turn on the ray-caster and enable process
	_tip_ray_cast.enabled = true
	set_process(true)


func let_go(p_linear_velocity = Vector3(), p_angular_velocity = Vector3()):
	# Call base
	.let_go(p_linear_velocity, p_angular_velocity)

	# Turn off the ray-caster and disable processing
	_tip_ray_cast.enabled = false
	set_process(false)
