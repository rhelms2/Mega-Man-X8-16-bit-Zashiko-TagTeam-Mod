extends AttackAbility
var times_fired: = 0
var fire_timer: = 0.0
export (PackedScene) var projectile
export  var proj_speed: = 50.0
onready var snow_origin: Node2D = $"../animatedSprite/snow_origin"
onready var snow_loop: AudioStreamPlayer2D = $snow_loop

func _Setup() -> void :
	attack_stage = 0
	times_fired = 0
	fire_timer = 0.0
	if not is_player_in_front():
		go_to_attack_stage( - 2)

func _Update(delta: float) -> void :
	process_gravity(delta)
	fire_timer += delta * 7
	
	if attack_stage == - 2:
		play_animation("turn")
		next_attack_stage()
	elif attack_stage == - 1 and has_finished_last_animation():
		turn()
		play_animation("prepare")
		next_attack_stage()
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("fire")
		play_fireloop()
		next_attack_stage()

	elif attack_stage == 1 and timer > 0.06:
		if times_fired < 30:
			var p = instantiate_projectile(projectile)
			direct_projectile(p)
			times_fired += 1
			go_to_attack_stage(1)
		else:
			stop_fireloop()
			play_animation("recover")
			next_attack_stage()

	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void :
	._Interrupt()
	stop_fireloop()

func play_fireloop() -> void :
	snow_loop.volume_db = - 8.5
	
func stop_fireloop() -> void :
	var tween = create_tween()
	tween.tween_property(snow_loop, "volume_db", - 50, 0.45)

func direct_projectile(proj: GenericProjectile) -> void :
	var v_multiplier = lerp( - 0.75, 0.5, abs(sin(fire_timer / 2)))
	proj.global_position = snow_origin.global_position
	proj.global_position.y += sin(fire_timer * 4)
	proj.set_vertical_speed(proj_speed * v_multiplier)
	proj.set_horizontal_speed(abs(proj_speed * 3.5) * character.get_facing_direction())
	if character.get_facing_direction() > 0:
		proj.flip()
