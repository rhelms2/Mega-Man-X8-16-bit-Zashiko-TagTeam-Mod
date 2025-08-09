extends GenericIntro
onready var spin: AudioStreamPlayer2D = $"../GigaStomp/spin"
onready var space: Node = $"../Space"

func prepare_for_intro() -> void:
	Log("Preparing for Intro")
	make_invisible()

func _Update(_delta) -> void:
	if attack_stage == 0:
		space.define_arena()
		character.global_position.y -= 100
		character.global_position.x += 100
		play_animation("thunder_loop")
		turn_and_face_player()
		make_visible()
		spin.play()
		character.global_position.x -= 100
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(character, "global_position:y", character.global_position.y+136, 1.0)
		tween_list.append(tween)
		next_attack_stage()

	elif attack_stage == 1 and timer > 1:
		play_animation("thunder_end")
		turn_player_towards_boss()
		next_attack_stage()

	elif attack_stage == 2 and has_finished_last_animation():
		play_animation_once("idle")
		start_dialog_or_go_to_attack_stage(4)
			
	elif attack_stage == 3:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 4:
		Event.emit_signal("play_boss_music")
		play_animation("roll_prepare")
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("thunder_loop")
		spin.play()
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()

	elif attack_stage == 6 and timer > 1.5:
		play_animation("intro")
		next_attack_stage()
	
	elif attack_stage == 7 and timer > 1:
		play_animation("intro_end")
		next_attack_stage()
		
	elif attack_stage == 8 and has_finished_last_animation():
		play_animation("idle")
		EndAbility()
