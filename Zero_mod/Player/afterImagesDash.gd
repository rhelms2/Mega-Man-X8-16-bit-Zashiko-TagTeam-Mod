extends Node

const subtle_motion: Array = [Vector2(1, 1), Vector2( - 1, - 1), Vector2(1, - 1), Vector2( - 1, 1), Vector2(0, 0)]

export  var active: bool = false
export  var frequency: float = 0.03
export  var duration: float = 0.125
export  var ignored_colors: Array = [
	Color(0, 0, 0), 
	Color(0, 0, 0), 
	Color(0, 0, 0), 
	Color(0, 0, 0), 
	Color(0, 0, 0), 
	Color(0, 0, 0), 
	Color(0, 0, 0), 
	Color(0, 0, 0)
]
export  var motion_amount: float = 0.0

onready var original: AnimatedSprite = $".."
onready var character = get_parent().get_parent()

var initial_color: Color = Color("#00000000")
var final_color: Color = Color("#00000000")
var upgraded: bool = false
var current_motion: = 0
var _rotator_script: Script = preload("res://System/misc/rotatordelete.gd")
var dash_states: Array = [
	"Dash", 
	"SaberDash", 
	"KnuckleDash", 
	"DashWallJump", 
	"AirDash", 
	"DashJump", 
	"AirJump", 
	"Fall", 
	"SaberJump", 
	"KnuckleJump", 
]
var ability_states: Array = [
	"Tenshouha", 
	"Juuhazan", 
	"Rasetsusen", 
	"Youdantotsu", 
	"Raikousen", 
	"Hyouryuushou", 
	"Enkoujin", 
	"Enkoukyaku"
]


func _process(_delta):
	if upgraded:
		for state in ability_states:
			if character.is_executing(state):
				activate()
				return
		for state in dash_states:
			if character.is_executing(state):
				if check_horizontal_velocity(state):
					activate()
					return
				else:
					deactivate()
					return
		deactivate()

func check_horizontal_velocity(state: String) -> bool:
	if character.is_executing(state):
		var node = character.get_node(state)
		if node.horizontal_velocity > 90:
			return true
	return false

func set_shader_colors():
	var material = original.get_material()
	if material is ShaderMaterial:
		initial_color = material.get_shader_param("R_SaberColor4")
		final_color = Color("#00000000")
	elif material is CanvasItemMaterial:
		initial_color = Color("#00000000")
		final_color = Color("#00000000")

func _ready() -> void :
	call_deferred("set_shader_colors")
	if active:
		afterimage_emit()

func activate():
	if not active:
		active = true
		afterimage_emit()

func deactivate():
	active = false

func set_afterimage_shader(_afterimage) -> void :
	var material = ShaderMaterial.new()
	material.shader = load("res://Zero_mod/Player/DashShader.shader")
	material.set_shader_param("display_color", initial_color)
	material.set_shader_param("ignored_color_1", ignored_colors[0])
	material.set_shader_param("ignored_color_2", ignored_colors[1])
	material.set_shader_param("ignored_color_3", ignored_colors[2])
	material.set_shader_param("ignored_color_4", ignored_colors[3])
	material.set_shader_param("ignored_color_5", ignored_colors[4])
	material.set_shader_param("ignored_color_6", ignored_colors[5])
	material.set_shader_param("ignored_color_7", ignored_colors[6])
	material.set_shader_param("ignored_color_8", ignored_colors[7])
	_afterimage.material = material

func afterimage_emit() -> void :
	if active:
		var afterimage: = AnimatedSprite.new()
		add_child(afterimage)
		equate_settings(afterimage)
		set_afterimage_shader(afterimage)
		fade_and_delete(afterimage)
		var rotator = Node.new()
		rotator.set_name("rotator")
		rotator.set_script(_rotator_script)
		afterimage.add_child(rotator)
		Tools.timer(frequency, "afterimage_emit", self)

func fade_and_delete(afterimage: AnimatedSprite) -> void :
	afterimage.modulate = initial_color
	var tween: = afterimage.create_tween().set_parallel(true)
	tween.tween_property(afterimage, "modulate", final_color, duration)
	tween.tween_property(afterimage, "position", afterimage.position + get_motion(), duration)
	tween.set_parallel(false)
	tween.tween_callback(afterimage, "queue_free")

func equate_settings(afterimage: AnimatedSprite) -> void :
	afterimage.scale = original.scale
	afterimage.frames = original.frames
	afterimage.animation = original.animation
	afterimage.frame = original.frame
	afterimage.playing = false
	afterimage.centered = original.centered
	afterimage.offset = original.offset
	afterimage.flip_h = original.flip_h
	afterimage.flip_v = original.flip_v
	afterimage.z_index = 1
	afterimage.global_position = original.global_position
	afterimage.rotation_degrees = original.rotation_degrees

func get_motion() -> Vector2:
	current_motion += 1
	if current_motion > subtle_motion.size() - 1:
		current_motion = 0
	return subtle_motion[current_motion] * motion_amount
