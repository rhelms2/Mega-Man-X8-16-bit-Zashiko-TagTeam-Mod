extends Particles2D
var timer := 0.0
export var should : bool

func _physics_process(delta: float) -> void:
	timer += delta
	#var alpha = round(abs(cos(timer * 42)) - 0.3)
	#var is_visible = alpha == 1
	#visible = is_visible
	#set_modulate ( Color(1,1,1, alpha) )
