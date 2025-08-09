extends BossWeaponAxl

const rastro_interval: float = 0.025

export  var pop_in_time: float = 0.032

onready var rastro: Sprite = $rastro
onready var line_2d: Line2D = $trail / line2D

var last_speed: Vector2
var last_position: Vector2
var rastro_timer: float = 0.0
var ending: bool = false
var timer: float = 0.0
var time_alive: float = 0.0
var time_alive_max: float = 3.0
var bounce_timer: int = 0
var bounce_max: int = 5
var bounce_factor_enemy: float = 1.35
var bounce_factor_scenery: float = 1.15
var on_ground: bool = false


func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	play_fire_sound()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	animatedSprite.rotation_degrees = - rotation_degrees

func _physics_process(delta: float) -> void :
	rastro_timer += delta
	time_alive += delta
	if stopped():
		timer += delta
		if timer > 0.2:
			destroy()
	if time_alive > time_alive_max:
		disable_visuals()
		timer += delta
		if timer > 0.2:
			destroy()
	else:
		if animatedSprite.visible and rastro_timer > rastro_interval:
			rastro.emit()
			rastro_timer = 0
			
		if has_hit_scenery() and bounce_timer < bounce_max:
			bounce()
	last_speed = Vector2(get_horizontal_speed(), get_vertical_speed())
	last_position = global_position
	animatedSprite.rotation_degrees = - rotation_degrees
	rastro.rotation_degrees = - rotation_degrees

func stopped() -> bool:
	return last_position == global_position

func disable_visuals() -> void :
	$animatedSprite.visible = false
	
	rastro.visible = false
	line_2d.visible = false

func add_bounce() -> void :
	bounce_timer += 1
	if bounce_timer >= bounce_max:
		set_vertical_speed(0)
		set_horizontal_speed(0)
		disable_visuals()

func bounce() -> void :
	damage *= bounce_factor_scenery
	break_guard_damage *= bounce_factor_scenery
	if is_instance_valid(get_slide_collision(0)):
		last_speed = last_speed.bounce(get_slide_collision(0).normal)
	
	
	set_vertical_speed(last_speed.y * 1.05)
	set_horizontal_speed(last_speed.x * 1.05)
	audio.play_rp(0.05, 2.0)
	update_facing_direction()
	add_bounce()

func bounce_b() -> void :
	damage = damage * bounce_factor_enemy
	var random: = rand_range( - PI / 8, PI / 8)
	last_speed = - last_speed
	set_vertical_speed(last_speed.y)
	set_horizontal_speed(last_speed.x)
	update_facing_direction()
	add_bounce()

func update_facing_direction() -> void :
	if get_horizontal_speed() > 0:
		set_direction(1)
	else:
		set_direction( - 1)

func hit(_body) -> void :
	_body.damage(damage, self)
	emit_signal("hit")
	bounce_b()

func deflect(_body) -> void :
	bounce_b()

func disable_particle_visual() -> void :
	pass

func emit_hit_particle() -> void :
	pass
