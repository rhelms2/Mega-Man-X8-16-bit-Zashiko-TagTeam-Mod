extends Reference
class_name AbilityStage

var ability
var current_stage: = 0
var _check: = 1
var ended: = false

func _init(_ability, connect: = true) -> void :
	ability = _ability
	if connect:
		ability.connect("stop", self, "reset")

func reset(_d = null) -> void :
	current_stage = 0
	ended = false
	reset_check()

func is_initial() -> bool:
	_check = 1
	return current_stage == 0

func on_next() -> bool:
	if ended:
		return false
	if current_stage == _check:
		_check = 1
		Log("Automatic stage check. Stage " + str(current_stage))
		return true
	else:
		_check += 1
	return false

func currently_is(stage: int) -> bool:
	_check = stage + 1
	Log("Manual stage check. Stage " + str(current_stage))
	return current_stage == stage

func get_current() -> int:
	return current_stage

func next():
	current_stage += 1
	reset_timer()
	reset_check()
	Log("proceeding to stage " + str(current_stage))

func end() -> void :
	current_stage += 1
	Log("ending on stage " + str(current_stage))
	ended = true

func resume() -> void :
	ended = false
	Log("resuming")
	

func previous_attack_stage() -> void :
	current_stage -= 1
	reset_timer()
	reset_check()
	Log("proceeding to stage " + str(current_stage))
	
func go_to_stage(new_stage: int) -> void :
	current_stage = new_stage
	reset_timer()
	reset_check()
	Log("proceeding to stage " + str(current_stage))

func deferred_next():
	call_deferred("next")
	
func deferred_go_to_stage(new_stage: int) -> void :
	call_deferred("go_to_stage", new_stage)

func reset_timer() -> void :
	ability.timer = 0

func reset_check() -> void :
	_check = 1

func Log(message) -> void :
	ability.Log(message)
