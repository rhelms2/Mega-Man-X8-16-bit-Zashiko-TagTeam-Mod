extends Line2D

export var length := 50
var point : Vector2
onready var dark_arrow: KinematicBody2D = $"../.."
var timer := 0.0
var fading := false

func _physics_process(delta: float) -> void:
	timer = timer + delta
	if timer > 0.032:
		point = dark_arrow.global_position 
		add_point(point)
		timer = 0
		while get_point_count() > length:
			remove_point(0)
	if fading:
		modulate = Color(1,1,1,dark_arrow.modulate.a)


func _on_DarkArrow_hit_ground() -> void:
	fading = true
	pass # Replace with function body.
