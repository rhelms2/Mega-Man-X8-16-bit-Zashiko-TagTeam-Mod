extends GenericIntro

export var projectile : PackedScene

func _Setup() -> void:
	GameManager.start_cutscene()
	attack_stage = -1

func spawn_box() -> void:
	var p = instantiate(projectile)
	p.global_position.y = character.global_position.y - 144
	p.global_position.x = character.global_position.x
	p.floor_position = character.global_position.y - 28

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == -1 and timer > 1:
		spawn_box()
		next_attack_stage()

	elif attack_stage == 0 and timer > 1:
		make_visible()
		turn_player_towards_boss()
		play_animation("land")
		next_attack_stage()

	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("idle")
		start_dialog_or_go_to_attack_stage(3)

	elif attack_stage == 2:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 3:
		Event.emit_signal("play_boss_music")
		play_animation("rage")
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.75:
		play_animation("ready")
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 1.25:
		play_animation("ready_end")
		next_attack_stage()

	elif attack_stage == 6 and has_finished_last_animation():
		play_animation("idle")
		EndAbility()
