extends SaberBaseZeroX8
class_name KnuckleComboZeroX8

onready var saber2_sound: AudioStreamPlayer = $saber2
onready var saber3_sound: AudioStreamPlayer = $saber3

var punches: int = 0

var input_buffer: Array = []
var buffer_window_threshold: int = 3


func hitbox_and_position() -> void :
	hitbox_damage = damage
	hitbox_damage_boss = damage_boss
	hitbox_damage_weakness = damage_weakness
	hitbox_break_guard_value = 1
	hitbox_rehit_time = 0.15
	if animatedSprite.frame >= 1 and animatedSprite.frame < 3:
		hitbox_upleft = Vector2(0, - 20)
		hitbox_downright = Vector2(38, 10)
		spawn_hitbox(hitbox_upleft, hitbox_downright)

	reset_hitbox()

func end_saber_state() -> bool:
	return ending_saber_state

func is_in_buffer_window() -> bool:
	if animatedSprite.animation == "saber_1" and animatedSprite.frame >= 5 - buffer_window_threshold:
		return true
	if animatedSprite.animation == "saber_2" and animatedSprite.frame >= 5 - buffer_window_threshold:
		return true
	return false

func should_add_saber_combo() -> bool:
	if animatedSprite.animation == "saber_1":
		return animatedSprite.frame >= 5
	if animatedSprite.animation == "saber_2":
		return animatedSprite.frame >= 5
	return false

func set_saber_animations() -> void :
	if character.is_on_floor():
		if punches == 0:
			animatedSprite.animation = "saber_1"
			punches += 1
			saber_sound.play()
		elif punches == 1:
			animatedSprite.animation = "saber_2"
			saber2_sound.play()
			punches = 0

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
		if not _animation == "saber_1" and not _animation == "saber_2":
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
	input_buffer = []
	set_saber_animations()
	ending_saber_state = false

func _Update(delta: float) -> void :
	hitbox_and_position()
	
	if is_in_buffer_window() and character.get_action_just_pressed(actions[0]):
		input_buffer.append(actions[0])
		
	if should_add_saber_combo() and input_buffer.size() > 0:
		input_buffer.pop_front()
		set_saber_animations()
	
	force_movement(0)

	process_gravity(delta)
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	._Interrupt()
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
