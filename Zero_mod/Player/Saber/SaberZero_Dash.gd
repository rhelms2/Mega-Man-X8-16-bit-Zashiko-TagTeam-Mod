extends SaberZeroBase
class_name SaberZeroDash

var horizontal_speed = horizontal_velocity
var damping = 0.97

func hitbox_and_position():
	if animatedSprite.animation == "saber_dash":
		hitbox_damage = 4
		hitbox_damage_boss = 4
		hitbox_damage_weakness = 24
		hitbox_break_guards = true
		hitbox_rehit_time = 0.025
		if animatedSprite.frame >= 2 and animatedSprite.frame < 5:
			hitbox_upleft = Vector2(7, - 22)
			hitbox_downright = Vector2(74, 18)
			spawn_hitbox(hitbox_upleft, hitbox_downright)
			
	reset_hitbox()

func end_saber_state():
	return animatedSprite.frame >= 10

func should_add_saber_combo():
	return false

func set_saber_animations():
	animatedSprite.animation = "saber_dash"
	saber_sound.play()
	
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
	horizontal_speed = horizontal_velocity
	update_bonus_horizontal_only_conveyor()
	slashing = false
	set_saber_animations()

func damp_horizontal_speed(_delta: float) -> void :
	var reference_delta = 1.0 / 120
	var damping_factor = pow(damping, _delta / reference_delta)
	horizontal_speed *= damping_factor

func _Update(_delta: float) -> void :
	hitbox_and_position()
	force_movement(horizontal_speed)
	damp_horizontal_speed(_delta)

	
	update_bonus_horizontal_only_conveyor()

func change_animation_if_falling(_s) -> void :
	pass

func _Interrupt():
	
	slashes = 0
	character.play_animation("saber_recover")
	if is_instance_valid(current_hitbox):
		current_hitbox.queue_free()
