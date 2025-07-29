extends WallJumpZero
class_name DashWallJumpZero
var override_timer: = 0.0
var overridden: = false

func _ready() -> void :
	Event.listen("input_dash", self, "on_dash_press")

func _Setup() -> void :
	._Setup()
	character.dashjumps_since_jump = 0
	overridden = false
	Event.emit_signal("dash")
	character.dashjump_signal()
	if override_timer > 0.0:
		override_dash()
	character.Rasetsusen_used = false
	character.Hyouryuushou_used = false

func override_dash() -> void :
	timer = override_timer
	override_timer = 0.0
	overridden = true

func _StartCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if _animation == "saber_slide":
			return true
		if not "saber_jump" in _animation:
			return false
		if "saber_jump" in _animation:
			if character.animatedSprite.frame < 5:
				return false
		return false
	if character.is_on_floor():
		return false
	if character.get_action_pressed(dash_action):
		if character.is_in_reach_for_walljump() != 0:
			return true
	return false

func change_animation_if_falling(_s) -> void :
	if character.is_executing("SaberJump") or character.is_executing("KnuckleJump"):
		return
	if not changed_animation:
		if character.get_animation() != "fall":
			if character.get_vertical_speed() > 0:
				EndAbility()
				character.start_dashfall()

func move_away_from_wall(_delta: float):
	character.set_horizontal_speed(horizontal_velocity * - character.get_facing_direction())

func on_touch_floor() -> void :
	.on_touch_floor()
	character.set_horizontal_speed(90 * character.get_pressed_axis())

func execute_dashwalljump_on_input() -> bool:
	return false

func start_right_away() -> void :
	Log("Executing directly, skipping sound and delay")
	play_sound_on_initialize()
	play_animation_on_initialize()
	ExecuteOnce()

func play_sound_on_initialize() -> void :
	if override_timer == 0:
		.play_sound_on_initialize()

func play_animation_on_initialize() -> void :
	if override_timer == 0:
		.play_animation_on_initialize()

func _ResetCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		if _animation == "saber_slide":
			if character.animatedSprite.frame >= 4:
				return true
		if not "saber_jump" in _animation:
			return false
		if "saber_jump" in _animation:
			if character.animatedSprite.frame < 5:
				return false
		return false
	if character.is_in_reach_for_walljump() and timer > 0.032:
		if Input.is_action_just_pressed(actions[0]):
			character.emit_signal("wallslide")
			return true
			
	return false

