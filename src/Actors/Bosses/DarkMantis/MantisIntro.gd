extends GenericIntro
onready var wallhit: AudioStreamPlayer2D = $wallhit
onready var land: AudioStreamPlayer2D = $land
onready var jump: AudioStreamPlayer2D = $jump

func prepare_for_intro() -> void:
	animatedSprite.visible = true
	set_starting_position()
	play_animation_once("wall_start")
	character.animatedSprite.set_frame(4)
	character.modulate = Color(0,0,0,0.5)

func _Setup() -> void:
	._Setup()
	var tween = get_tree().create_tween()
	tween.tween_property(character,"modulate",Color(1,1,1,1),0.5)

func _Update(delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("walljump_prepare")
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("walljump")
		force_movement(600)
		jump.play()
		next_attack_stage_on_next_frame()

	elif attack_stage == 2:
		process_gravity(delta/3)
		if has_finished_last_animation():
			play_animation_once("walljump_loop")
		if is_colliding_with_wall():
			force_movement(0)
			wallhit.play()
			adjust_position_to_wall()
			turn()
			play_animation_once("wall_start")
			next_attack_stage_on_next_frame()
			decay_vertical_speed(0.15)

	elif attack_stage == 3 and timer > 0.35:
		play_animation_once("walljump_prepare")
		next_attack_stage_on_next_frame()

	elif attack_stage == 4 and has_finished_last_animation():
		play_animation_once("walljump")
		force_movement(600)
		jump.play()
		next_attack_stage_on_next_frame()

	elif attack_stage == 5:
		process_gravity(delta)
		if has_finished_last_animation():
			play_animation("walljump_loop")
		if character.is_on_floor():
			turn_and_face_player()
			turn_player_towards_boss()
			wallhit.play()
			play_animation_once("land")
			decay_speed(-0.35, 0.5)
			next_attack_stage()

	elif attack_stage == 6:
		start_dialog_or_go_to_attack_stage(8)
	
	elif attack_stage == 7 and timer > 0.5:
		play_animation_once("idle")
		if dialog_concluded:
			next_attack_stage()
	
	elif attack_stage == 8:
		play_animation_once("intro")
		Event.emit_signal("play_boss_music")
		next_attack_stage_on_next_frame()
	
	elif attack_stage == 9 and has_finished_last_animation():
		Event.emit_signal("boss_health_appear", character)
		if timer > 3:
			EndAbility()

func _Interrupt() -> void:
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	character.emit_signal("intro_concluded")

func set_starting_position() -> void:
	var top = get_distance_from_ceiling()
	var wall = get_wall_position(1)
	var initial_position = Vector2(wall - 21, character.global_position.y - top + 32)
	Log("top: " + str(top + 32))
	Log("Initial Position: " + str(initial_position))
	character.global_position = initial_position
