extends WeaponShot
class_name Lemon

var hit_time := 0.0

func _physics_process(delta: float) -> void:
	process_hittime(delta)

func references_setup(direction):
	set_direction(direction)
	animatedSprite.scale.x = direction
	$particles2D.scale.x = direction
	update_facing_direction()
	$animatedSprite.set_frame(int(rand_range(0,8)))
	original_pitch = audio.pitch_scale

func process_hittime(delta):
	if hit_time > 0:
		hit_time += delta

	if hit_time > time_outside_screen /3:
		disable_particle_visual()

func hit(target):
	if active:
		hit_time = 0.01
		countdown_to_destruction = 0.01
		target.damage(damage, self)
		#if target.is_in_group("Enemies"):
		#	Event.emit_signal("hit_enemy")
		emit_hit_particle()
		disable_projectile_visual()
		call_deferred("disable_damage")
		remove_from_group("Player Projectile")

func leave(_target):
	pass

func deflect(_body) -> void:
	.deflect(_body)
	$deflect_particle.emit(facing_direction)

func launch_setup(direction, _launcher_velocity := 0.0):
	set_horizontal_speed(horizontal_velocity * direction)

func disable_damage():
	$collisionShape2D.disabled = true
	
