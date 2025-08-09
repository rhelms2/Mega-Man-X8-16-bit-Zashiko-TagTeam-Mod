extends DashJumpAxl

export  var upgraded: = false

onready var _hover_effect = character.get_node("animatedSprite").get_node("HoverEffect")

var max_air_jumps: = 1
var current_air_jumps: = 0
var vertical_velocity = 90
var should_end_walljump: = false
var should_end_dashwalljump: = false
var _hover
var emitted_hover: = false


func _ready() -> void :
	if active:
		character.listen("land", self, "reset_jump_count")
		character.listen("ride", self, "reset_jump_count")
		character.listen("wallslide", self, "reset_jump_count")
		character.listen("walljump", self, "reset_jump_count")
		character.listen("airdash", self, "reduce_air_jumps")
		character.listen("firedash", self, "reduce_air_jumps")

func set_max_air_jumps(value: int):
	max_air_jumps = value
	current_air_jumps = value
	Log("setting max airjumps:" + str(current_air_jumps))

func _Setup():
	interrupt_if_needed()
	reduce_air_jumps(1)
	._Setup()

func emit_dashjump() -> void :
	pass

func reset_jump_count(_dummy: = null):
	current_air_jumps = max_air_jumps
	Log("resetting amount of airjumps:" + str(current_air_jumps))

func reduce_air_jumps(amount: = 1):
	Log("Reducing amount of airjumps by " + str(amount))
	current_air_jumps -= amount

func _StartCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation == "dodge":
		return false
	if character.ride_eject_delay > 0:
		return false
	if current_air_jumps <= 0:
		if not upgraded:
			return false
	if not character.is_on_floor():
		if character.time_since_on_floor > leeway_time:
			var walljump = character.get_executing_ability("WallJump")
			var dashwalljump = character.get_executing_ability("DashWallJump")
			if not walljump and not dashwalljump:
				reset_interrupt_bools()
				return true
			else:
				if walljump:
					if walljump.timer > 0.25:
						should_end_walljump = true
						return true
				if dashwalljump:
					if dashwalljump.timer > 0.25:
						should_end_dashwalljump = true
						return true
	return false

func start_hover_effect():
	if not emitted_hover:
		_hover_effect.visible = true
		_hover_effect.playing = true
		_hover_effect.frame = 0
		emitted_hover = true

func reset_hover_effect():
	if emitted_hover:
		_hover_effect.visible = false
		_hover_effect.playing = false
		emitted_hover = false

func play_hover_sound():
	if _hover_effect.frame == 0:
		$audioStreamPlayer.playing = true

func should_hover() -> bool:
	if not has_let_go_of_input:
		if not character.is_on_floor():
			if not facing_a_wall():
				if upgraded:
					return true
				if not Has_time_ran_out():
					return true
	return false

func _Update(_delta: float) -> void :
	if should_hover():
		start_hover_effect()
		play_hover_sound()
		zero_bonus_horizontal_speed()
		if character.is_shooting:
			set_movement_and_direction(0)
			character.set_vertical_speed(0)
		else:
			set_movement_and_direction(horizontal_velocity, _delta)
			if character.get_animation() != "hover":
				character.play_animation("hover")
			if Input.is_action_pressed("move_up"):
				character.set_vertical_speed( - vertical_velocity)
			elif Input.is_action_pressed("move_down"):
				character.set_vertical_speed(vertical_velocity)
			else:
				character.set_vertical_speed(0)
	else:
		reset_hover_effect()
		change_animation_if_falling("fall")
		set_movement_and_direction(horizontal_velocity)
		process_gravity(_delta)
		





func reset_interrupt_bools():
	should_end_walljump = false
	should_end_dashwalljump = false

func interrupt_if_needed():
	if should_end_walljump:
		interrupt("WallJump")
	elif should_end_dashwalljump:
		interrupt("DashWallJump")
	reset_interrupt_bools()
	reset_hover_effect()

func interrupt(ability: String):
	Log("Ending " + ability)
	character.force_end(ability)
	reset_hover_effect()

func _Interrupt() -> void :
	character.dashfall = false
	._Interrupt()
	reset_hover_effect()

func check_for_let_go_of_input():
	if input == 0:
		has_let_go_of_input = true

func _ResetCondition() -> bool:



	return false

func change_animation_if_falling(_s) -> void :
	if not changed_animation:
		if character.get_animation() != "fall":
			if character.get_vertical_speed() > 0:
				EndAbility()

func Has_time_ran_out() -> bool:
	return max_jump_time < timer

func _EndCondition() -> bool:
	if Has_time_ran_out() and not upgraded:
		reset_hover_effect()
		return true
	if pressing_towards_wall() or character.is_on_floor():
		reset_hover_effect()
		return true
	return false
