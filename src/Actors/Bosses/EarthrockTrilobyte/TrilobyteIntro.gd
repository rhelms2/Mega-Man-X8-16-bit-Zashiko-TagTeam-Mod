extends GenericIntro

onready var crystal: AnimatedSprite = $crystal
onready var crystal_2: AnimatedSprite = $crystal2
onready var crystal_3: AnimatedSprite = $crystal3
onready var crystals = [crystal, crystal_2, crystal_3]
onready var break_sound: AudioStreamPlayer2D = $break
onready var appear: AudioStreamPlayer2D = $appear

func prepare_for_intro() -> void:
	make_invisible()
	for c in crystals:
		c.visible = false
	
func _Setup() -> void:
	GameManager.start_cutscene()
	turn_and_face_player()
	repeat_for_all_crystals("introduce")

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and timer > 1:
		repeat_for_all_crystals("shatter_and_break")
		turn_player_towards_boss()
		make_visible()
		play_animation("rage_prepare")
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation_again("rage_loop")
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 1:
		play_animation_again("rage_end")
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 1.25:
		play_animation_again("rage_to_idle")
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("idle")
		start_dialog_or_go_to_attack_stage(6)
		
	elif attack_stage == 5:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 6:
		Event.emit_signal("play_boss_music")
		play_animation("ready")
		next_attack_stage()
		
	elif attack_stage == 7 and timer > 0.5:
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()

	elif attack_stage == 8 and timer > 1.25:
		next_attack_stage()
	
	elif attack_stage == 9 and has_finished_last_animation():
		play_animation("idle")
		EndAbility()

func _Interrupt() -> void:
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	character.emit_signal("intro_concluded")

func repeat_for_all_crystals(method : String, time_between := 0.1) -> void:
	var interval := 0.0165
	for c in crystals:
		Tools.timer_p(interval,method,self,c)
		interval += time_between

func introduce(crystal_sprite : AnimatedSprite) -> void:
	crystal_sprite.visible = true
	crystal_sprite.playing = true
	crystal_sprite.frame = 0
	crystal_sprite.play("intro")
	appear.play_rp()

func shatter_and_break(crystal_sprite : AnimatedSprite) -> void:
	crystal_sprite.play("shattered")
	break_sound.play_rp(0.05,1.85)
	Tools.timer_p(1.0,"_break",self,crystal_sprite)

func _break(crystal_sprite : AnimatedSprite) -> void:
	crystal_sprite.visible = false
	break_sound.play_rp()
	get_node(crystal_sprite.name + "_remains").emitting = true
