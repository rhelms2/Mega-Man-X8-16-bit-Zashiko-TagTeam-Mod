extends Line2D

var timer := 0.0
func _physics_process(delta: float) -> void:
	if visible:
		timer += delta
		modulate.a = range_lerp(sin(timer*120),-1,1,0,1)
