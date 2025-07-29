extends AttackAbility

onready var boss_ai = get_parent().get_node("BossAI")

onready var rasetsusen: Node2D = $rasetsusen
onready var rasetsusen_sfx = get_node("rasetsusen/rasetsusen_sfx")

onready var dash_smoke: Particles2D = $"../animatedSprite/Dash Smoke Particles"


onready var sfx_saber1: AudioStreamPlayer = get_parent().get_node("saber")
onready var sfx_saber2: AudioStreamPlayer = get_parent().get_node("saber2")
onready var sfx_saber3: AudioStreamPlayer = get_parent().get_node("saber3")
onready var sfx_dash: AudioStreamPlayer = get_parent().get_node("dash")
onready var sfx_jump: AudioStreamPlayer = get_parent().get_node("jump")
onready var sfx_land: AudioStreamPlayer = get_parent().get_node("land")


func _Setup() -> void :
	turn_and_face_player()
	play_animation("idle")

func _Update(delta: float) -> void :
	process_gravity(delta)
	
	if attack_stage == 0:
		play_animation("dash")
		sfx_dash.play()
		
		dash_smoke.emitting = true
		force_movement(320)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.1:
		if is_player_nearby_horizontally(48) and is_player_nearby_vertically(32) or timer > 1 or facing_a_wall():
			play_animation("jump_dodge")
			if boss_ai.used_desperation:
				play_animation("rasetsusen")
				rasetsusen.activate()
				rasetsusen_sfx.stream.loop = true
				rasetsusen_sfx.play()
				force_movement( - 320)
				set_vertical_speed( - 400)
			else:
				force_movement( - 250)
				set_vertical_speed( - 300)
				
			sfx_jump.play()
			call_deferred("decay_speed", 1, 1.25)
			dash_smoke.emitting = false
			next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.1:
		if get_vertical_speed() > 0:
			kill_tweens(tween_list)
			play_animation("fall")
			rasetsusen.deactivate()
			rasetsusen_sfx.stop()
			next_attack_stage()
			
	elif attack_stage == 3 and timer > 0.1:
		if character.is_on_floor():
			play_animation("recover")
			sfx_land.play()
			force_movement(0)
			go_to_attack_stage(10)
	
	elif attack_stage == 10:
		EndAbility()

func _Interrupt() -> void :
	._Interrupt()
	rasetsusen_sfx.stop()
	dash_smoke.emitting = false
