extends SimplePlayerProjectile

onready var particles: Particles2D = $particles2D
onready var remains: Particles2D = $remains_particles
var wallstuck: = false
var stuck_timer: = 0.0

func _Update(delta: float) -> void :
	if not wallstuck:
		._Update(delta)
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			wall_hit()
	else:
		stuck_timer += delta
		if stuck_timer > 1 and not ending:
			shatter()
		if ending and timer > 1:
			destroy()

func wall_hit() -> void :
	animatedSprite.visible = true
	if is_collided_moving():
		remains.emitting = true
		disable_visuals()
		return
	wallstuck = true
	disable_damage()
	stop()
	particles.emitting = false
	modulate = Color(1, 1, 1, 0.2)
	if timer < 0.05:
		shatter()

func shatter() -> void :
	modulate = Color(1, 1, 1, 0.5)
	remains.emitting = true
	disable_visuals()
	ending = true

func enable_visuals() -> void :
	particles.emitting = true
	.enable_visuals()

func disable_visuals():
	particles.emitting = false
	.disable_visuals()
	
func _OnHit(_target_remaining_HP) -> void :
	remains.emitting = true
	._OnHit(_target_remaining_HP)
	
func _OnDeflect() -> void :
	remains.emitting = true
	._OnDeflect()
