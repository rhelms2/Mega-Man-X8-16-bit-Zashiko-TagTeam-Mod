extends SimpleProjectile

var ending := false
var last_speed : Vector2
var bounces := 0
var last_bounce := 0.0
const max_bounces := 8
const destroyer := true

func _Update(delta) -> void:
	if not ending:
		if timer > 0.15:
			process_gravity(delta, 400)
		if is_on_floor() or is_on_ceiling():
			bounce()
		if is_on_wall():
			bounce()
		if bounces >= max_bounces:
			explode()
		
	#set_rotation(Vector2(get_horizontal_speed(),get_vertical_speed()).angle())
	last_speed = Vector2(get_horizontal_speed(),get_vertical_speed())
	
	if ending and timer > 0.5:
		destroy()

func bounce() -> void:
		last_speed = last_speed.bounce(get_slide_collision(0).normal)
		set_vertical_speed(last_speed.y/1.1)
		set_horizontal_speed(last_speed.x/1.1)
		bounces += 1
		last_bounce = timer
		if bounces < max_bounces:
			#sound.play_rp()
			pass

func explode() -> void:
	disable_visuals()
	deactivate()
	set_rotation(0)
	hitparticle.emit()

func _OnHit(_d) -> void:
	explode()
	hitparticle.emit()
	disable_visuals()

func rotate_towards_direction() -> void:
	set_rotation(Vector2(get_horizontal_speed(),get_vertical_speed()).angle())
