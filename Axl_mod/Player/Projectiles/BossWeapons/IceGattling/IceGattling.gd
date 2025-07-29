extends BossWeaponAxl

onready var pause_script: Script = preload("res://Zero_mod/System/PauseInstance.gd")
onready var start_particle: = get_node("Start Particle")
onready var particles: Particles2D = $particles2D
onready var remains: Particles2D = $remains_particles

var hit_time: float = 0.0
var emitted_start_particle: bool = false
var ending: bool = false
var timer: float = 0.0
var rotation_speed: int = 15
var pause_duration: float = 2.0


func _ready() -> void :
	._ready()

func rotate_bullet() -> void :
	var rotate_dir = get_facing_direction()
	var _rotate_speed = rotation_speed * rand_range( - 2, 2)
	animatedSprite.rotation_degrees += rotate_dir * _rotate_speed

func _physics_process(delta: float) -> void :
	if not ending:
		rotate_bullet()
		particles.process_material.direction = Vector3(horizontal_velocity, vertical_velocity, 0)
		particles.emitting = true
		if has_hit_scenery():
			on_wall_hit()
			return
	else:
		timer += delta
		if timer > 0.5:
			destroy()
	._physics_process(delta)

func on_wall_hit() -> void :
	animatedSprite.visible = false
	disable_damage()
	stop()
	particles.emitting = false
	countdown_to_destruction = 0.01
	shatter()

func shatter() -> void :
	play_sound(hit_sound, - 10, true)
	if get_facing_direction() > 0:
		remains.rotation_degrees = 0
	else:
		remains.rotation_degrees = 180
	remains.emitting = true
	disable_visuals()
	ending = true

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

func track_and_freeze_enemy(target) -> void :
	if target is BossDamage:
		target.damage(damage, self)
	else:
		if "character" in target:
			if target.character.current_health > 0:
				target.freeze_hits += 1
				if target.freeze_hits >= target.max_freeze_hits:
					freeze_enemy(target)

func freeze_enemy(target) -> void :
	var existing_pause_node = target.get_parent().get_node_or_null("Pause Enemy")
	if existing_pause_node != null:
		target.damage(damage, self)
	else:
		var pause_node = Node.new()
		pause_node.set_name("Pause Enemy")
		pause_node.set_script(pause_script)
		pause_node.pause_duration = pause_duration
		pause_node.paused_color = Color("#84d6e7")
		pause_node.frozen = true
		target.get_parent().add_child(pause_node)
		pause_node.start_pause(target.get_parent(), 0, self)
		target.damage(damage, self)

func hit(target) -> void :
	if active:
		hit_time = 0.01
		countdown_to_destruction = 0.01
		target.damage(damage, self)
		remains.emitting = true
		particles.emitting = false
		shatter()
		disable_projectile_visual()
		call_deferred("disable_damage")
		remove_from_group("Player Projectile")
		track_and_freeze_enemy(target)

func emit_hit_particle() -> void :
	pass

func enable_visuals() -> void :
	particles.emitting = true
	.enable_visuals()

func disable_visuals() -> void :
	particles.emitting = false
	$animatedSprite.visible = false

func leave(_target) -> void :
	pass

func deflect(_body) -> void :
	.deflect(_body)
	shatter()

func launch_setup(_direction, _launcher_velocity: float = 0.0) -> void :
	if get_facing_direction() > 0:
		rotation = deg2rad(0)
		remains.rotation_degrees = 0
	else:
		rotation = deg2rad(180)
		remains.rotation_degrees = 180
	animatedSprite.scale.x = get_facing_direction()
	animatedSprite.scale.y = get_facing_direction()
	set_horizontal_speed(horizontal_velocity + rand_range( - 10, 10))
	set_vertical_speed(vertical_velocity + rand_range( - 10, 10))
	
	emit_start_particle()

func emit_start_particle() -> void :
	if not emitted_start_particle:
		start_particle.global_position = global_position
		start_particle.emit()
		emitted_start_particle = true

func disable_damage() -> void :
	$collisionShape2D.disabled = true
