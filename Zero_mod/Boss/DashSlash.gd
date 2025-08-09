extends AttackAbility

onready var boss_ai = get_parent().get_node("BossAI")

onready var dashslash: Node2D = $dashslash
onready var hyouryuushou: Node2D = $hyouryuushou
onready var hyouryuushou_sfx = get_node("hyouryuushou/hyouryuushou_sfx")
onready var hyouryuushou_particles = get_node("hyouryuushou/particles2D")

onready var raikousen: Node2D = $raikousen
onready var dash_smoke: Particles2D = $"../animatedSprite/Dash Smoke Particles"


onready var sfx_saber1: AudioStreamPlayer = get_parent().get_node("saber")
onready var sfx_saber2: AudioStreamPlayer = get_parent().get_node("saber2")
onready var sfx_saber3: AudioStreamPlayer = get_parent().get_node("saber3")
onready var sfx_dash: AudioStreamPlayer = get_parent().get_node("dash")
onready var sfx_jump: AudioStreamPlayer = get_parent().get_node("jump")
onready var sfx_land: AudioStreamPlayer = get_parent().get_node("land")


func _Setup() -> void :
	turn_and_face_player()
	play_animation("attack_start")
	dashslash.handle_direction()
	hyouryuushou.handle_direction()
	particle_position()
	if boss_ai.used_desperation:
		dashslash.damage = 8
		hyouryuushou.damage = 8

func _Update(delta: float) -> void :
	process_gravity(delta)
	particle_position()
	
	if attack_stage == 0:
		play_animation("dash")
		sfx_dash.play()
		
		dash_smoke.emitting = true
		force_movement(320)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.1:
		if is_player_nearby_horizontally(64.0) or timer > 1 or facing_a_wall():
			if is_player_nearby_vertically(24):
				play_animation("saber_dash")
				sfx_saber2.play()
				dashslash.activate()
				force_movement(250)
				dash_smoke.emitting = false
				next_attack_stage()
			else:
				hyouryuushou_slash()
				go_to_attack_stage(5)
	
	elif attack_stage == 2 and timer > 0.2 and has_finished_last_animation():
			kill_tweens(tween_list)
			turn_and_face_player()
			dashslash.handle_direction()
			hyouryuushou.handle_direction()
			call_deferred("decay_speed", 0.5, 0.2)
			play_animation("idle")
			next_attack_stage()
			
	elif attack_stage == 3 and timer > 0.1:
			kill_tweens(tween_list)
			play_animation("dash")
			sfx_dash.play()
			dash_smoke.emitting = true
			force_movement(320)
			next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.05:
		if is_player_nearby_horizontally(48) or facing_a_wall():
			hyouryuushou_slash()
			next_attack_stage()

	elif attack_stage == 5 and timer > 0.1:
		if get_vertical_speed() > 0:
			play_animation("fall")
			next_attack_stage()
			hyouryuushou_particles.emitting = false
			
	elif attack_stage == 6 and timer > 0.1:
		if character.is_on_floor():
			play_animation("recover")
			sfx_land.play()
			force_movement(0)
			go_to_attack_stage(10)
	
			
	elif attack_stage == 10 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void :
	._Interrupt()
	dash_smoke.emitting = false
	hyouryuushou_particles.emitting = false

func hyouryuushou_slash():
	hyouryuushou.activate()
	play_animation("hyouryuushou")
	force_movement(200)
	set_vertical_speed( - 400)
	call_deferred("decay_speed", 1, 1.25)
	hyouryuushou_sfx.play()
	particle_position()
	
	dash_smoke.emitting = false

func particle_position():
	hyouryuushou_particles.position = Vector2(25 * get_facing_direction(), - 3)
	hyouryuushou_particles.z_index = animatedSprite.z_index + 1
