extends BambooGrenade


func _ready() -> void :
	animatedSprite.playing = true

func _Update(delta: float) -> void :
	process_gravity(delta)
	if is_on_floor():
		explode()
