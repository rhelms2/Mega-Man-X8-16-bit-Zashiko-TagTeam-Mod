extends WeaponShot
class_name PistolBullet

onready var start_particle: = get_node("Start Particle")

var emitted_start_particle: bool = false
var hit_time: float = 0.0
var timer: float = 0.0
var blue_bullet: bool = false


func _physics_process(delta: float) -> void :
	if active:
		if has_hit_scenery():
			on_wall_hit()
			return
	else:
		timer += delta
		if timer > 0.2:
			destroy()
		return
	process_hittime(delta)

func on_wall_hit() -> void :
	emit_hit_particle()
	deactivate()
	disable_damage()

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

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	.deflect(_body)
	$deflect_particle.emit(facing_direction)

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
		$deflect_particle.rotation_degrees = 0
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
		$deflect_particle.rotation_degrees = 180
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity)
	set_vertical_speed(vertical_velocity)
	set_rotation(Vector2(get_horizontal_speed(), get_vertical_speed()).angle())
	emit_start_particle()
	if blue_bullet:
		get_node("animatedSprite").play("Blue")
		break_guards = true

func emit_start_particle() -> void :
	if not emitted_start_particle:
		start_particle.global_position = global_position
		start_particle.emit()
		emitted_start_particle = true

func disable_damage() -> void :
	$collisionShape2D.disabled = true
