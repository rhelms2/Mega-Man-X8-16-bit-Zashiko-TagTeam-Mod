extends Line2D

export var length := 50
var point : Vector2
export var object_to_follow : NodePath
onready var character := get_node(object_to_follow)
var timer := 0.0
var fading := false

func _ready() -> void:
	modulate = default_color
	var _s = character.connect("visibled",self,"make_visible")
	_s = character.connect("hidden",self,"make_invisible")
	
func make_visible() -> void:
	visible = true

func make_invisible() -> void:
	visible = false

func _physics_process(delta: float) -> void:
	z_index = character.z_index - 1
	timer = timer + delta
	if timer > 0.032:
		point = character.global_position
		add_point(point)
		timer = 0
		while get_point_count() > length:
			remove_point(0)
