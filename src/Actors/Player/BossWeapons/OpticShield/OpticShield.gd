extends SimplePlayerProjectile

onready var shockwave: AnimatedSprite = $shockwave


func _Setup() -> void :
	animatedSprite.playing = true
	animatedSprite.frame = 0
	shockwave.playing = true
	shockwave.frame = 0

func _OnDeflect() -> void :
	pass

func _OnHit(_target_remaining_HP) -> void :
	disable_damage()
	timer = 0

func _Update(_delta: float) -> void :
	if timer > 0.1:
		disable_damage()
	if timer > 1.25:
		destroy()

func set_direction(_new_direction):
	pass
