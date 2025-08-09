extends AttackAbility

var pursuing_armor := false
var grabbed_armor := false
onready var guard_break: Node = $"../GuardBreak"
onready var tween = TweenController.new(self,false)
onready var dash_smoke: Particles2D = $dash_smoke

func on_catch_armor() -> void:
	if executing:
		pursuing_armor = false
		go_to_attack_stage(2)

func _Setup() -> void:
	turn_and_face_player_or_armor()

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		tween.method("force_movement",0.0,horizontal_velocity,0.1)
		play_animation("run")
		next_attack_stage()
	if attack_stage == 1: #running
		if facing_a_wall():
			go_to_attack_stage(2)
		elif timer > 0.35 and has_missed_target():
			go_to_attack_stage(2)
		elif timer > 1.0:
			go_to_attack_stage(2)
	
	elif attack_stage == 2: #stopping:
		tween.method("force_movement",get_actual_speed(),0.0,0.6)
		play_animation("run_end")
		dash_smoke.emitting = true
		next_attack_stage()
	elif attack_stage == 3:
		if timer > 0.35:
			dash_smoke.emitting = false
		if has_finished_last_animation():
			EndAbility()

func has_missed_target() -> bool:
	if pursuing_armor:
		return get_facing_direction() != get_armor_direction_relative()
	return get_facing_direction() != get_player_direction_relative()

func _Interrupt() -> void:
	pursuing_armor = false
	dash_smoke.emitting = false
	force_movement(0)

func turn_and_face_player_or_armor() -> void:
	if has_no_armor():
		turn_and_face_armor()
	else:
		turn_and_face_player()

func has_no_armor() -> bool:
	return is_instance_valid(guard_break.armor)

func turn_and_face_armor():
	set_direction(get_armor_direction_relative())
	pursuing_armor = true

func get_armor_direction_relative() -> int:
	if guard_break.armor.global_position.x > character.global_position.x:
		return(1)
	else:
		return(-1)

