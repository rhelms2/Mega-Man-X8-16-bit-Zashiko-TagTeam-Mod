extends Sprite

export  var speed: = 100.0

func _process(delta: float) -> void :
	region_rect.position.x += delta * speed
