extends Line2D

export  var length: = 50
var point: Vector2
onready var character = get_parent().get_parent()
var timer: = 0.0
var fading: = false

func _physics_process(delta: float) -> void :
	timer = timer + delta
	if timer > 0.032:
		point = character.global_position
		point.y -= 5.0
		add_point(point)
		timer = 0
		while get_point_count() > length:
			remove_point(0)

