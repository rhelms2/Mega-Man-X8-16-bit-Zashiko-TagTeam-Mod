extends GenericIntro
onready var appear: AudioStreamPlayer2D = $"../OpticTeleport/appear"
onready var leaves: Particles2D = $"../OpticTeleport/leaves"
export var bar : Texture

func _Setup() -> void:
	Log("Setup Intro")
	GameManager.start_cutscene()
	turn_and_face_player()

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and timer > 1:
		Log("Setup Intro")
		make_visible()
		turn_player_towards_boss()
		appear.play()
		play_animation("tp_appear_prepare")
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("tp_appear")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("idle")
		start_dialog_or_go_to_attack_stage(4)
	
	elif attack_stage == 3:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 4:
		Event.emit_signal("play_boss_music")
		leaves.emitting = true
		leaves.z_index = 0
		play_animation("ready")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.5:
		Event.emit_signal("set_boss_bar",bar)
		Event.emit_signal("boss_health_appear", character)
		leaves.emitting = false
		leaves.z_index = 1
		next_attack_stage()

	elif attack_stage == 6 and timer > 1.5:
		play_animation("ready_end")
		next_attack_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("idle")
		EndAbility()

func _Interrupt() -> void:
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	character.emit_signal("intro_concluded")
