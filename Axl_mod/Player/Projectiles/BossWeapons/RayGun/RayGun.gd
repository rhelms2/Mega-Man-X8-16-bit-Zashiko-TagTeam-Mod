extends BossWeaponAxl

onready var start_particle: = get_node("Start Particle")
onready var light: Light2D = $light

var hit_time: float = 0.0
var emitted_start_particle: bool = false
var ending: bool = false
var timer: float = 0.0
var light_color: Color = Color("#74DCFF")


func _ready() -> void :
	._ready()

func _physics_process(delta: float) -> void :
	if active:
		light.light(0.5 * rand_range(0.9, 1.1), Vector2(1.5 * rand_range(0.9, 1.1), 1 * rand_range(0.9, 1.1)), light_color)
		if has_hit_scenery():
			on_wall_hit()
			return
	else:
		light.light(0, Vector2(0, 0), Color("#000000"))
		timer += delta
		if timer > 0.2:
			destroy()
		return
	._physics_process(delta)

func on_wall_hit() -> void :
	emit_hit_particle()
	animatedSprite.visible = false
	stop()
	disable_damage()
	deactivate()

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
	if hit_time > time_outside_screen / 3:
		disable_particle_visual()

func hit(target) -> void :
	if active:
		hit_time = 0.01
		countdown_to_destruction = 0.01
		target.damage(damage, self)
		emit_hit_particle()
		disable_projectile_visual()
		call_deferred("disable_damage")
		remove_from_group("Player Projectile")
		active = false

func emit_hit_particle() -> void :
	if not emitted_hit_particle:
		hit_particle.emit()
		emitted_hit_particle = true

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	.deflect(_body)
	$deflect_particle.emit()

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	light.light(0.5, Vector2(1.5, 1), light_color)
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	emit_start_particle()

func emit_start_particle() -> void :
	if not emitted_start_particle:
		start_particle.global_position = global_position
		start_particle.emit()
		emitted_start_particle = true

func disable_damage() -> void :
	$collisionShape2D.disabled = true
