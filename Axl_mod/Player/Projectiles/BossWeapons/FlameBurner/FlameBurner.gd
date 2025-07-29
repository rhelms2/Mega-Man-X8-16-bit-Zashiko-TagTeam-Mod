extends BossWeaponAxl

onready var start_particle: = get_node("Start Particle")
onready var light: Light2D = $light

var hit_time: float = 0.0
var emitted_start_particle: bool = false
var ending: bool = false
var timer: float = 0.0
var light_color: Color = Color.orange


func process_movement() -> void :
	pass

func _physics_process(delta: float) -> void :
	handle_collision(delta)
	timer += delta
	if timer > 0.3:
		disable_damage()
		animatedSprite.modulate = Color(1, 1, 1, 1 - timer)
		light.dim(0.5, 0)
	else:
		light.light(0.3 * rand_range(0.9, 1.1), Vector2(3 * rand_range(0.9, 1.1), 2 * rand_range(0.9, 1.1)), light_color)
	set_horizontal_speed(get_horizontal_speed() * (1 - timer / 15))
	set_vertical_speed(get_vertical_speed() * (1 - timer / 15))
	if timer > 1:
		destroy()

func on_wall_hit() -> void :
	pass

func deactivate() -> void :
	active = false
	disable_projectile_visual()
	call_deferred("disable_damage")
	remove_from_group("Player Projectile")

func references_setup(direction) -> void :
	set_direction(direction)
	animatedSprite.scale.x = direction
	update_facing_direction()
	$animatedSprite.set_frame(int(rand_range(0, 2)))
	original_pitch = audio.pitch_scale

func process_hittime(delta: float) -> void :
	if hit_time > 0:
		hit_time += delta

func hit(target) -> void :
	if active:
		target.damage(damage, self)
		call_deferred("disable_damage")
		remove_from_group("Player Projectile")
		active = false

func emit_hit_particle() -> void :
	pass

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	pass

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	light.light(0.3, Vector2(3, 2), light_color)
	animatedSprite.playing = true
	if rand_range(0.0, 1.0) > 0.5:
		animatedSprite.flip_v = true
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity + rand_range( - 50, 50))
	set_vertical_speed(vertical_velocity + rand_range( - 50, 50))
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())

func disable_damage() -> void :
	$collisionShape2D.disabled = true
