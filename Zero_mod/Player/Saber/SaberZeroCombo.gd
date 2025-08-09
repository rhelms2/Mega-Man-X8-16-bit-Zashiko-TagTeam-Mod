extends SaberZeroBase
class_name SaberComboZero
onready var saber2_sound: AudioStreamPlayer = $saber2
onready var saber3_sound: AudioStreamPlayer = $saber3

var input_buffer = []
var buffer_window_threshold = 3

func hitbox_and_position():
	if animatedSprite.animation == "saber_1":
		hitbox_damage = 2
		hitbox_damage_boss = 4
		hitbox_damage_weakness = 24
		hitbox_rehit_time = 0.1
		if animatedSprite.frame >= 2 and animatedSprite.frame < 6:
			hitbox_upleft = Vector2( - 5, - 38)
			hitbox_downright = Vector2(52, 16)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	if animatedSprite.animation == "saber_2":
		hitbox_damage = 4
		hitbox_damage_boss = 8
		hitbox_damage_weakness = 24
		hitbox_rehit_time = 0.1
		if animatedSprite.frame >= 2 and animatedSprite.frame < 3:
			hitbox_upleft = Vector2( - 5, - 9)
			hitbox_downright = Vector2(55, 3)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
		if animatedSprite.frame >= 3 and animatedSprite.frame < 4:
			hitbox_upleft = Vector2( - 40, - 9)
			hitbox_downright = Vector2(55, 6)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
		if animatedSprite.frame >= 4 and animatedSprite.frame < 6:
			hitbox_upleft = Vector2( - 40, - 9)
			hitbox_downright = Vector2(5, 6)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	if animatedSprite.animation == "saber_3":
		hitbox_damage = 12
		hitbox_damage_boss = 8
		hitbox_damage_weakness = 24
		hitbox_rehit_time = 0.2
		hitbox_break_guards = true
		if animatedSprite.frame >= 2 and animatedSprite.frame < 6:
			hitbox_upleft = Vector2( - 25, - 34)
			hitbox_downright = Vector2(18, - 15)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
		if animatedSprite.frame >= 3 and animatedSprite.frame < 6:
			hitbox_upleft = Vector2( - 5, - 39)
			hitbox_downright = Vector2(68, 21)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

func end_saber_state():
	if animatedSprite.animation == "saber_1":
		return animatedSprite.frame >= 9
	if animatedSprite.animation == "saber_2":
		return animatedSprite.frame >= 10
	if animatedSprite.animation == "saber_3":
		return animatedSprite.frame >= 13
	return false

func is_in_buffer_window() -> bool:
	if animatedSprite.animation == "saber_1" and animatedSprite.frame >= 6 - buffer_window_threshold:
		return true
	if animatedSprite.animation == "saber_2" and animatedSprite.frame >= 6 - buffer_window_threshold:
		return true
	return false

func should_add_saber_combo():
	if animatedSprite.animation == "saber_1":
		return animatedSprite.frame >= 6
	if animatedSprite.animation == "saber_2":
		return animatedSprite.frame >= 6
	if animatedSprite.animation == "saber_3":
		return false
	return false

func set_saber_animations():
	if character.is_on_floor():
		if slashes == 0:
			animatedSprite.animation = "saber_1"
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
	slashes = 0
	input_buffer = []
	character.play_animation("saber_recover")
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
