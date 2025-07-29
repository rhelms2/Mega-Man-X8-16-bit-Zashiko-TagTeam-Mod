extends SaberBaseZeroX8
class_name SaberComboZeroX8

onready var saber2_sound: AudioStreamPlayer = $saber2
onready var saber3_sound: AudioStreamPlayer = $saber3
onready var breaker_sound: AudioStreamPlayer = $breaker

var input_buffer: Array = []
var buffer_window_threshold: int = 3


func hitbox_and_position():
	if animatedSprite.animation == "saber_1":
		if character.saber_node.current_weapon.name == "Saber":
			hitbox_damage = damage
			hitbox_damage_boss = damage_boss
			hitbox_damage_weakness = damage_weakness
			hitbox_rehit_time = 0.1
			hitbox_break_guards = false
			if animatedSprite.frame >= 2 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2( - 5, - 42)
				hitbox_downright = Vector2(72, 14)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "B-Fan":
			hitbox_damage = damage
			hitbox_damage_boss = damage_boss
			hitbox_damage_weakness = damage_weakness
			hitbox_rehit_time = 0.1
			hitbox_break_guards = false
			if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
				hitbox_upleft = Vector2( - 5, - 42)
				hitbox_downright = Vector2(72, 14)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			if animatedSprite.frame >= 3 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2(35, - 42)
				hitbox_downright = Vector2(72, 34)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "D-Glaive":
			hitbox_damage = damage
			hitbox_damage_boss = damage_boss
			hitbox_damage_weakness = damage_weakness
			hitbox_rehit_time = 0.05
			hitbox_break_guards = false
			if animatedSprite.frame >= 0 and animatedSprite.frame < 1:
				hitbox_upleft = Vector2( - 100, - 60)
				hitbox_downright = Vector2( - 65, 0)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
				hitbox_upleft = Vector2( - 65, - 80)
				hitbox_downright = Vector2( - 35, - 30)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 1 and animatedSprite.frame < 2:
				hitbox_upleft = Vector2( - 35, - 103)
				hitbox_downright = Vector2(59, - 75)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
				hitbox_upleft = Vector2(29, - 75)
				hitbox_downright = Vector2(59, - 30)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 2 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2(59, - 75)
				hitbox_downright = Vector2(127, 10)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "T-Breaker":
			hitbox_damage = damage
			hitbox_damage_boss = damage_boss
			hitbox_damage_weakness = damage_weakness
			hitbox_rehit_time = 0.1
			hitbox_break_guards = true
			if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
				hitbox_upleft = Vector2( - 5, - 68)
				hitbox_downright = Vector2(75, 0)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 3 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2(35, - 48)
				hitbox_downright = Vector2(90, 38)
				spawn_hitbox(hitbox_upleft, hitbox_downright)


	if animatedSprite.animation == "saber_2":
		if character.saber_node.current_weapon.name == "Saber":
			hitbox_damage = 4
			hitbox_damage_boss = 6
			hitbox_damage_weakness = 24
			hitbox_rehit_time = 0.1
			hitbox_break_guards = false
			if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
				hitbox_upleft = Vector2( - 5, - 20)
				hitbox_downright = Vector2(65, 10)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			if animatedSprite.frame >= 3 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2( - 50, - 30)
				hitbox_downright = Vector2(55, - 4)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "B-Fan":
			hitbox_damage = 4
			hitbox_damage_boss = 6
			hitbox_damage_weakness = 24
			hitbox_rehit_time = 0.1
			hitbox_break_guards = false
			if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
				hitbox_upleft = Vector2( - 5, - 30)
				hitbox_downright = Vector2(65, 20)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			if animatedSprite.frame >= 3 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2( - 60, - 50)
				hitbox_downright = Vector2(55, 6)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "D-Glaive":
			hitbox_damage = 4
			hitbox_damage_boss = 6
			hitbox_damage_weakness = 24
			hitbox_rehit_time = 0.05
			hitbox_break_guards = false
			if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
				hitbox_upleft = Vector2( - 5, - 20)
				hitbox_downright = Vector2(93, 17)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 3 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2( - 105, - 40)
				hitbox_downright = Vector2(0, - 15)
				spawn_hitbox(hitbox_upleft, hitbox_downright)


	if animatedSprite.animation == "saber_3":
		if character.saber_node.current_weapon.name == "Saber":
			hitbox_damage = 12
			hitbox_damage_boss = 8
			hitbox_damage_weakness = 24
			hitbox_rehit_time = 0.2
			hitbox_break_guards = true
			if animatedSprite.frame >= 3 and animatedSprite.frame < 6:
				hitbox_upleft = Vector2(0, - 59)
				hitbox_downright = Vector2(73, 21)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "B-Fan":
			hitbox_damage = 12
			hitbox_damage_boss = 8
			hitbox_damage_weakness = 24
			hitbox_rehit_time = 0.2
			hitbox_break_guards = true
			if animatedSprite.frame >= 3 and animatedSprite.frame < 6:
				hitbox_upleft = Vector2(0, - 70)
				hitbox_downright = Vector2(73, 21)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

		elif character.saber_node.current_weapon.name == "D-Glaive":
			hitbox_damage = 12
			hitbox_damage_boss = 8
			hitbox_damage_weakness = 24
			hitbox_rehit_time = 0.1
			hitbox_break_guards = true
			if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
				hitbox_upleft = Vector2( - 72, 44)
				hitbox_downright = Vector2(50, 74)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 3 and animatedSprite.frame < 4:
				hitbox_upleft = Vector2(50, 24)
				hitbox_downright = Vector2(110, 74)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 4 and animatedSprite.frame < 5:
				hitbox_upleft = Vector2(85, - 32)
				hitbox_downright = Vector2(133, 30)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
			elif animatedSprite.frame >= 5 and animatedSprite.frame < 6:
				hitbox_upleft = Vector2(55, - 52)
				hitbox_downright = Vector2(118, - 32)
				spawn_hitbox(hitbox_upleft, hitbox_downright)
				hitbox_upleft = Vector2(35, - 112)
				hitbox_downright = Vector2(98, - 52)
				spawn_hitbox(hitbox_upleft, hitbox_downright)

	reset_hitbox()

func end_saber_state():
	return ending_saber_state

func is_in_buffer_window() -> bool:
	if animatedSprite.animation == "saber_1" and animatedSprite.frame >= 7 - buffer_window_threshold:
		return true
	if animatedSprite.animation == "saber_2" and animatedSprite.frame >= 7 - buffer_window_threshold:
		return true
	return false

func should_add_saber_combo():
	if character.saber_node.current_weapon.name == "T-Breaker":
		return false
	if animatedSprite.animation == "saber_1":
		return animatedSprite.frame >= 7
	if animatedSprite.animation == "saber_2":
		return animatedSprite.frame >= 7
	if animatedSprite.animation == "saber_3":
		return false
	return false

func set_saber_animations():
	if character.is_on_floor():
		if slashes == 0:
			animatedSprite.animation = "saber_1"
			if character.saber_node.current_weapon.name == "T-Breaker":
				breaker_sound.play()
			else:
				saber_sound.play()
		if slashes == 1:
			animatedSprite.animation = "saber_2"
			saber2_sound.play()
		if slashes == 2:
			animatedSprite.animation = "saber_3"
			saber3_sound.play()
	slashes += 1

func _StartCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		return false
	if not executing:
		if character.is_on_floor():
			return true
	return false

func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if not _animation == "saber_1" and not _animation == "saber_2" and not _animation == "saber_3":
			return true
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	update_bonus_horizontal_only_conveyor()
	changed_animation = false
	slashing = false
	slashes = 0
	input_buffer = []
	set_saber_animations()
	ending_saber_state = false

func _Update(_delta: float) -> void :
	hitbox_and_position()
	
	if is_in_buffer_window() and character.get_action_just_pressed(actions[0]):
		input_buffer.append(actions[0])
		
	if should_add_saber_combo() and input_buffer.size() > 0:
		input_buffer.pop_front()
		set_saber_animations()
	
	force_movement(0)
	process_gravity(_delta)
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt():
	._Interrupt()
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
