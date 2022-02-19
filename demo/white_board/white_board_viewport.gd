tool
class_name WhiteBoardViewport
extends Viewport


# Sprite step-size for erasing
const ERASE_STEP_SIZE := 30.0

# Sprite step-size for marking
const MARK_STEP_SIZE := 4.0

# Node references
onready var _clear : ColorRect = $Clear
#onready var _marks : Node2D = $Marks
onready var _line : Line2D = $Line
onready var _erase : ColorRect = $Erase
onready var _erase_material : ShaderMaterial = $Erase.material


func clear(var color: Color):
	# Configure the node
	_clear.color = color
	_clear.rect_position = Vector2.ZERO
	_clear.rect_size = size
	
	# Set visibility
	_clear.visible = true
	_line.visible = false
	_erase.visible = false

	# Trigger rendering
	render_target_update_mode = Viewport.UPDATE_ONCE


func mark(var from: Vector2, var to: Vector2, var color: Color, var radius: float):
	var dir := (to - from).normalized()
	var head := dir * radius
	_line.width = radius * 2
	_line.points = PoolVector2Array([ from - head, to + head ])
	_line.default_color = color
	
	# Set visibility
	_clear.visible = false
	_line.visible = true
	_erase.visible = false
	
	# Trigger rendering
	render_target_update_mode = Viewport.UPDATE_ONCE


func erase(var _from: Vector2, var to: Vector2, var color: Color, var radius: float):
	# Configure the erase rectangle
	_erase.color = color
	_erase.rect_position = to - Vector2(radius, radius)
	_erase.rect_size = Vector2(radius*2, radius*2)
	
	# Set visibility
	_clear.visible = false
	_line.visible = false
	_erase.visible = true
	
	# Trigger rendering
	render_target_update_mode = Viewport.UPDATE_ONCE
