extends Sprite

export  var max_alpha: = 0.5
var timer: = 0.0

func _ready() -> void :
	var fire = get_node_or_null("animatedSprite")
	if fire != null:
		fire.frame = round(randf() * 10)
		if randf() > 0.5:
			fire.flip_h = true

func _physics_process(delta: float) -> void :
	timer += delta
	self_modulate.a = lerp(0.01, max_alpha, abs(sin(timer * 45)))
