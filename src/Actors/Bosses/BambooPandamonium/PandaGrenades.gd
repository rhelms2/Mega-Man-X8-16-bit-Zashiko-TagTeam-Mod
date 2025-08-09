extends AttackAbility

export var grenade :PackedScene
onready var shot: AudioStreamPlayer2D = $shot
onready var prepare: AudioStreamPlayer2D = $prepare
onready var claw_appear: AudioStreamPlayer2D = $claw_appear

func _Setup() -> void:
	._Setup()
	claw_appear.play()
	Tools.timer(0.6,"screenshake",self)
	Tools.timer(0.6,"play",prepare)

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("grenade_shot")
		shoot_grenade()
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("grenade_shot2")
		shoot_grenade(get_max_grenade_distance(),-350,Vector2(22 * character.get_facing_direction(),0))
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("grenade_shot")
		shoot_grenade(210,-350)
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("grenade_shot2")
		shoot_grenade(100,-350,Vector2(22 * character.get_facing_direction(),0))
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.5:
		play_animation("grenade_end")
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		EndAbility()

func get_max_grenade_distance() -> float:
	return clamp(get_distance_from_player(),260,400)

func shoot_grenade(h_speed := 120.0, v_speed = -350.0, adjust_position := Vector2.ZERO) -> void:
	shot.play_rp()
	var p = instantiate_projectile(grenade)
	p.set_horizontal_speed(h_speed * character.get_facing_direction())
	p.set_vertical_speed(v_speed)
	p.global_position += adjust_position
