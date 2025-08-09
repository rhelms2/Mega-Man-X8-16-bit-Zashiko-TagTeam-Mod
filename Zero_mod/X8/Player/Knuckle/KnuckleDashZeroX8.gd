extends SaberBaseZeroX8
class_name KnuckleDashZeroX8

var horizontal_speed: float = horizontal_velocity
var damping: float = 0.95

var vulnerable: bool = false
var start_speed: float = 400
var movement_frame_start: int = 0
var movement_frame_end: int = 12
var hitbox_frame_start: int = 5
var hitbox_frame_end: int = 10
var sound_frame: int = 3
var sound_played: bool = false


func hitbox_and_position() -> void :
	if animatedSprite.animation == "saber_dash":
		hitbox_damage = damage
		hitbox_damage_boss = damage_boss
		hitbox_damage_weakness = damage_weakness
		hitbox_break_guards = true
		hitbox_rehit_time = 0.025
		if animatedSprite.frame >= hitbox_frame_start and animatedSprite.frame < hitbox_frame_end:
			hitbox_upleft = hitbox_upleft_corner
			hitbox_downright = hitbox_downright_corner
			spawn_hitbox(hitbox_upleft, hitbox_downright)
	reset_hitbox()

func end_saber_state() -> bool:
	return ending_saber_state

func movement_speed_frames() -> bool:
	return animatedSprite.frame >= movement_frame_start and animatedSprite.frame < movement_frame_end

func set_saber_animations() -> void :
	animatedSprite.animation = "saber_dash"

func should_add_saber_combo() -> bool:
	return false

func play_skill_sound() -> void :
	if not sound_played:
		if animatedSprite.frame >= sound_frame:
			saber_sound.play()
			sound_played = true

func _StartCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		return false
	if not executing:
		if _animation == "dash":
			return true
	return false

func _ResetCondition() -> bool:
	return false

func _EndCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if end_saber_state():
			return true
	else:
		return true
	return false

func _Setup() -> void :
	sound_played = false
	horizontal_speed = start_speed
	update_bonus_horizontal_only_conveyor()
	set_saber_animations()
	ending_saber_state = false

func damp_horizontal_speed(delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, delta / reference_delta)
	horizontal_speed *= damping_factor

func process_invulnerability() -> void :
	if vulnerable:
		if animatedSprite.frame >= movement_frame_start and animatedSprite.frame < movement_frame_end - 2:
			character.add_invulnerability(name)
		else:
			character.remove_invulnerability(name)

func _Update(delta: float) -> void :
	hitbox_and_position()
	play_skill_sound()
	if movement_speed_frames():
		force_movement(horizontal_speed)
		damp_horizontal_speed(delta)
	else:
		force_movement(0)
	update_bonus_horizontal_only_conveyor()
	process_invulnerability()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt() -> void :
	
	character.dashjumps_since_jump = 0
	character.dashfall = false
	character.remove_invulnerability(name)
	if character.is_on_floor():
		animatedSprite.animation = "recover"
	else:
		animatedSprite.animation = "fall"
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
