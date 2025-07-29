extends Sprite

var timer: = 0.0
export  var multiplier: = 5.0

func _physics_process(delta: float) -> void :
	timer += delta
	modulate.a = inverse_lerp( - 1.0, 1.0, sin(timer * multiplier))
