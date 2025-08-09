extends DashJumpZero

onready var airdash: = character.get_node("AirDash")
var max_air_jumps: int = 1
var current_air_jumps: int = 0
var should_end_walljump: bool = false
var should_end_dashwalljump: bool = false


func _ready() -> void :
	if active:
		character.listen("land", self, "reset_jump_count")
		character.listen("ride", self, "reset_jump_count")
		character.listen("wallslide", self, "reset_jump_count")
		character.listen("walljump", self, "reset_jump_count")
		character.listen("airdash", self, "reduce_air_jumps")
		character.listen("firedash", self, "reduce_air_jumps")

func _Setup() -> void :
	interrupt_if_needed()
	reduce_air_jumps(1)
	reduce_airdash_count(1)
	if character.get_action_pressed("dash"):
		horizontal_velocity = dashjump_speed
		character.dashjump_signal()
	else:
		character.dashjumps_since_jump = 0
		horizontal_velocity = fall_base_velocity
	._Setup()

func reset_jump_count(_dummy: = null):
	current_air_jumps = max_air_jumps

func reduce_air_jumps(amount: = 1):
	current_air_jumps -= amount
	
func reduce_airdash_count(amount: = 1) -> void :
	airdash.airdash_count -= amount
	
func emit_dashjump() -> void :
	pass
	
func set_max_air_jumps(value: int):
	max_air_jumps = value
	current_air_jumps = value
	Log("setting max airjumps:" + str(current_air_jumps))

func _StartCondition() -> bool:
	var _animation = get_parent().get_animation()
	if _animation in character.saber_animations:
		return false
	if current_air_jumps <= 0 and airdash.airdash_count <= 0:
		return false
	if character.ride_eject_delay > 0:
		return false
	if not character.is_on_floor():
		if character.time_since_on_floor > leeway_time and character.is_in_reach_for_walljump() == 0:
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

func _Update(_delta: float) -> void :
	._Update(_delta)
	if character.get_animation() == "double_jump":
		if character.animatedSprite.frame >= 9:
			character.animatedSprite.animation = "jump"

func reset_interrupt_bools():
	should_end_walljump = false
	should_end_dashwalljump = false

func interrupt_if_needed():
	if should_end_walljump:
		interrupt("WallJump")
	elif should_end_dashwalljump:
		interrupt("DashWallJump")
	reset_interrupt_bools()

func interrupt(ability: String):
	Log("Ending " + ability)
	character.force_end(ability)
	
func change_animation_if_falling(_s) -> void :
	if not changed_animation:
		if character.get_animation() != "fall":
			if character.get_vertical_speed() > 0:
				EndAbility()
				if horizontal_velocity == dashjump_speed:
					character.start_dashfall()

func _EndCondition() -> bool:
	if character.is_executing("WallJump") or character.is_executing("DashWallJump"):
		return true
	return ._EndCondition()
