extends AttackAbility
export var crystal : PackedScene
export var warning : PackedScene
var target : float
signal start

func _Setup() -> void:
	turn_and_face_player()
	play_animation("hit_prepare")
	target = GameManager.get_player_position().x
	create_warning(80 * get_facing_direction())
	emit_signal("start")

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and timer > 0.5:
		play_animation("hit1")
		create_warning(-80 * get_facing_direction())
		create_crystal(80 * get_facing_direction())
		screenshake(0.7)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation("hit2")
		create_warning()
		create_crystal(-80 * get_facing_direction())
		screenshake(0.4)
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 0.5:
		play_animation("hit1")
		create_crystal()
		screenshake(0.3)
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("hit_end")
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()

func create_warning(x_offset := 0.0) -> void:
	var w = instantiate(warning)
	w.global_position = Vector2(target + x_offset,global_position.y +24)

func create_crystal(x_offset := 0.0) -> void:
	var c = instantiate(crystal)
	c.global_position = Vector2(target + x_offset,global_position.y - 8)
	connect("start",c,"break_crystal")
	#c.initialize(200 * get_player_direction_relative())
