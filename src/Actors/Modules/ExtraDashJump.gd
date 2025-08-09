extends DashJump

var max_air_jumps := 0
var current_air_jumps := 0
onready var jump_particle = get_node("jump_particle")
var should_end_walljump := false
var should_end_dashwalljump := false

func _ready() -> void:
	if active:
		character.listen("land",self,"reset_jump_count")
		character.listen("ride",self,"reset_jump_count")
		character.listen("wallslide",self,"reset_jump_count")
		character.listen("walljump",self,"reset_jump_count")
		character.listen("airdash",self,"reduce_air_jumps")
		character.listen("firedash",self,"reduce_air_jumps")

func set_max_air_jumps(value : int):
	max_air_jumps = value
	current_air_jumps = value
	Log("setting max airjumps:" + str(current_air_jumps))

func _Setup():
	interrupt_if_needed()
	reduce_air_jumps(2)
	jump_particle.emit(1)
	if character.get_action_pressed("dash"):
		horizontal_velocity = 210
		character.dashjump_signal()
	else:
		horizontal_velocity = 90
	._Setup()

func emit_dashjump() -> void: #overriding so it wont be called twice
	#character.dashjump_signal()
	pass
	
func reset_jump_count(_dummy := null):
	current_air_jumps = max_air_jumps
	Log("resetting amount of airjumps:" + str(current_air_jumps))

func reduce_air_jumps(amount := 1):
	Log("Reducing amount of airjumps by " + str(amount))
	current_air_jumps -= amount
	

func _StartCondition() -> bool:
	if current_air_jumps <= 0:
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

func reset_interrupt_bools():
	should_end_walljump = false
	should_end_dashwalljump = false

func interrupt_if_needed():
	if should_end_walljump:
		interrupt("WallJump")
	elif should_end_dashwalljump:
		interrupt("DashWallJump")
	reset_interrupt_bools()


func interrupt(ability : String):
	Log("Ending " + ability)
	character.force_end(ability)
	

func change_animation_if_falling(_s) -> void:
	if not changed_animation:
		if character.get_animation() != "fall":
			if character.get_vertical_speed() > 0:
				EndAbility()
				if horizontal_velocity == 210:
					character.start_dashfall()

func _EndCondition() -> bool:
	if character.is_executing("WallJump") or character.is_executing("DashWallJump"):
		return true
	return ._EndCondition()
