extends BossWeaponAxl

const rastro_interval: float = 0.05
const bypass_shield: bool = true

onready var start_particle: = get_node("Start Particle")
onready var remains: Particles2D = $remains_particles
onready var rastro: Sprite = $rastro

var hit_time: float = 0.0
var emitted_start_particle: bool = false
var ending: bool = false
var timer: float = 0.0
var rastro_timer: float = 0.0
var rastro_flip: bool = false


func process_movement() -> void :
	pass

func _physics_process(delta: float) -> void :
	rastro_timer += delta
	if animatedSprite.visible and rastro_timer > rastro_interval:
		if rastro_flip:
			rastro.flip_v = false
			rastro_flip = false
		else:
			rastro.flip_v = true
			rastro_flip = true
		rastro.emit()
		rastro_timer = 0
	if active:
		handle_collision(delta)
	timer_since_spawn += delta
	if timer_since_spawn > 1:
		if not visibilityNotifier.is_on_screen():
			destroy()

func _on_visibilityNotifier2D_screen_entered() -> void :
	countdown_to_destruction = 0.0

func _on_visibilityNotifier2D_screen_exited() -> void :
	countdown_to_destruction = 0.0

func deactivate() -> void :
	active = false
	emit_hit_particle()
	disable_projectile_visual()
	call_deferred("disable_damage")
	remove_from_group("Player Projectile")

func references_setup(direction) -> void :
	set_direction(direction)
	animatedSprite.scale.x = direction
	update_facing_direction()
	$animatedSprite.set_frame(int(rand_range(0, 2)))
	original_pitch = audio.pitch_scale

func hit(target) -> void :
	target.damage(damage, self)

func emit_hit_particle() -> void :
	pass

func leave(_target) -> void :
	pass

func _OnHit(_v) -> void :
	pass

func deflect(_body) -> void :
	pass

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	if get_facing_direction() > 0:
		get_node("animatedSprite").rotation = deg2rad(0)
	else:
		get_node("animatedSprite").rotation = deg2rad(180)
	remains.process_material.direction.x = rotation - 2
	remains.process_material.direction.y = get_facing_direction() * - 3
	remains.emitting = true
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
