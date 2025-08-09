extends GenericIntro
onready var land: AudioStreamPlayer2D = $land
onready var jump: AudioStreamPlayer2D = $jump
onready var kick: AudioStreamPlayer2D = $kick
signal prepared

func prepare_for_intro() -> void:
	animatedSprite.visible = true
	animatedSprite.modulate = Color("97764a")
	set_starting_position()
	character.scale = Vector2(0.5,0.5)
	play_animation("appear_loop")
	screenshakes()
	emit_signal("prepared")

func set_starting_position() -> void:
	var top = get_distance_from_ceiling()
	var wall = get_wall_position(1)
	var initial_position = Vector2(wall - 161, character.global_position.y - top + 224/2)
	initial_position.y += 2
	character.global_position = initial_position

func screenshakes():
	if animatedSprite.animation == "appear_loop":
		screenshake(.8)
		Tools.timer(0.8,"screenshakes",self)

func _Update(_delta) -> void:
	if attack_stage == 0:
		if timer > 1.75:
			play_animation("appear_end")
			next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("idle")
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 0.75:
		play_animation("jump_prepare")
		jump.play()
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		turn()
		play_animation("jump")
		go_to_start_position()
		next_attack_stage()

	elif attack_stage == 4:
		process_gravity(_delta)
		if timer > 0.25 and character.is_on_floor():
			next_attack_stage()

	elif attack_stage == 5:
		play_animation("land")
		turn_player_towards_boss()
		land.play()
		screenshake(.9)
		turn_player_towards_boss()
		turn_and_face_player()
		force_movement(-80)
		decay_speed(1,0.35)
		next_attack_stage()

	elif attack_stage == 6 and timer > 0.4:
		play_animation("idle")
		start_dialog_or_go_to_attack_stage(8)

	elif attack_stage == 7:
		if seen_dialog():
			next_attack_stage()

	elif attack_stage == 8:
		Event.emit_signal("play_boss_music")
		Event.emit_signal("boss_health_appear", character)
		play_animation("knee_prepare")
		next_attack_stage()

	elif attack_stage == 9 and has_finished_last_animation():
		play_animation("knee_prepare_loop")
		next_attack_stage()

	elif attack_stage == 10 and timer > 0.85:
		play_animation("kick_end")
		kick.play()
		next_attack_stage()

	elif attack_stage == 11 and has_finished_last_animation():
		play_animation_once("idle")
		if timer > 0.35:
			EndAbility()

func go_to_start_position() -> void:
	set_vertical_speed(-jump_velocity)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(character,"global_position:x",global_position.x+120,1)
	tween.tween_property(animatedSprite,"modulate",Color.white,1)
	tween.tween_property(character,"scale",Vector2(1.0,1.0),1)

