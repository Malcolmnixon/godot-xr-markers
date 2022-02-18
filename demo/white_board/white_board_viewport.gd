class_name WhiteBoardViewport
extends Viewport


# Sprite step-size for erasing
const ERASE_STEP_SIZE := 30.0

# Sprite step-size for marking
const MARK_STEP_SIZE := 4.0

# Node references
onready var _clear : ColorRect = $Clear
onready var _marks : Node2D = $Marks
onready var _erase : Sprite = $Erase
onready var _erase_material : ShaderMaterial = $Erase.material


func clear(var color: Color):
	# Configure the node
	_clear.color = color
	_clear.rect_position = Vector2.ZERO
	_clear.rect_size = size
	
	# Set visibility
	_clear.visible = true
	_marks.visible = false
	_erase.visible = false

	# Trigger rendering
	render_target_update_mode = Viewport.UPDATE_ONCE


func mark(var color: Color, var from: Vector2, var to: Vector2):
	# Configure the top mark
	_marks.modulate = color
	
	# Configure the child marks
	var mark_sprites := _marks.get_children()
	var mark_sprite_count := mark_sprites.size()
	var lerp_scale := 1.0 / (mark_sprite_count - 1)
	for i in mark_sprite_count:
		mark_sprites[i].offset = lerp(from, to, i * lerp_scale)
	
	# Set visibility
	_clear.visible = false
	_marks.visible = true
	_erase.visible = false
	
	# Trigger rendering
	render_target_update_mode = Viewport.UPDATE_ONCE


func erase(var color: Color, var from: Vector2, var to: Vector2):
	# Configure the node
	_erase_material.set_shader_param("erase", color)
	_erase.offset = to
	
	# Set visibility
	_clear.visible = false
	_marks.visible = false
	_erase.visible = true
	
	# Trigger rendering
	render_target_update_mode = Viewport.UPDATE_ONCE
