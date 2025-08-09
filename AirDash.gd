extends Dash
class_name AirDash

#default airdash duration: 0.475
onready var airjump = character.get_node("AirJump")
var should_reduce_airjumps := false
var infinite_airdashes := false
var max_airdashes := 1
var airdash_count := 1
#var was_dashjumping := false
onready var wall_jump: Node2D = $"../WallJump"
onready var dash_wall_jump: Node2D = $"../DashWallJump"
onready var air_jump: Node2D = $"../AirJump"
var initial_direction := 1
var initial_sound := true

func _ready() -> void:
	character.listen("land",self,"reset_airdash_count")
	character.listen("wallslide",self,"reset_airdash_count")
	character.listen("walljump",self,"reset_airdash_count")
	character.listen("dashjump",self,"reduce_airdash_count")
	character.listen("firedash",self,"firedash_reduce_airdash_count")
	#character.listen("jump",self,"reset_airdash_count")

func _Setup() -> void:
	._Setup()
	character.set_vertical_speed(0)
	reduce_air_jumps()
	airdash_count -= 1
	left_ground_timer = 0.0
	initial_direction = character.get_facing_direction()
	character.activate_low_walljump_raycasts()
	Event.emit_signal("airdash")
	character.airdash_signal()
	$label.text = str(airdash_count)

func reset_airdash_count() -> void:
	airdash_count = max_airdashes
	$label.text = str(airdash_count)
	Log("Resetting airdashes")
	
func firedash_reduce_airdash_count():
	if not character.is_on_floor():
		reduce_airdash_count()
	
func reduce_airdash_count() -> void:
	airdash_count -= 1
	$label.text = str(airdash_count)
	Log("Reducing airdashes on dashjump signal to " + str(airdash_count))

func should_dash() -> bool:
	if not has_let_go_of_input:
		if not character.is_on_floor():
			if not Has_time_ran_out():
				if not facing_a_wall():
					return true
	return false
	
func change_animation_if_falling(_s) -> void:
	EndAbility()
	character.start_dashfall()

func on_dash() -> void:
	if pressed_inverse_direction():
		pass

func pressed_inverse_direction() -> bool:
	if timer > 0.1:
		if get_pressed_direction() != 0 and initial_direction != get_pressed_direction():
			Log("Inverse direction detected")
			return true
	else:
		initial_direction = get_pressed_direction()
	return false

func check_for_let_go_of_input():
	if input == 0 or pressed_inverse_direction():
		has_let_go_of_input = true
		

func emit_particles(_particles, _value:=false):
	#disabling smoke particles
	pass

func _ResetCondition() -> bool:
	if has_let_go_of_input and Input.is_action_just_pressed(actions[0]): #talvez de problema no futuro, checando input diretamente
		if character.get_vertical_speed() > 0:
			if airjump.active and airjump.current_air_jumps > 0 and airdash_count > 0:
				airjump.reduce_air_jumps()
				return true
			elif infinite_airdashes and airdash_count > 0:
				return true
	return false

func _StartCondition() -> bool:
	if should_dash():
		if is_executing_WallJump():
			return false
		elif airdash_count > 0:
			return true
		
	return false


func reduce_air_jumps() -> void:
	if should_reduce_airjumps:
		Log("Reducing airjumps by 1")
		if airjump.debug_logs:
			print_debug("X.AirDash: Forcing reduce of AirJumps")
		airjump.reduce_air_jumps()
		should_reduce_airjumps = false
	

func is_executing_DashAirJump() -> bool:
	return air_jump.executing and abs(air_jump.horizontal_velocity) > 90

func is_executing_WallJump() -> bool:
	if dash_wall_jump.executing and dash_wall_jump.timer < 0.2:
		return true
	elif wall_jump.executing and wall_jump.timer < 0.2:
		return true
	return false

func is_executing_DashJump() -> bool:
	return character.dashjumps_since_jump > 0

func is_able_to_airjump() -> bool:
	return airjump.active and airjump.current_air_jumps > 0

func _Interrupt():
	last_time_pressed = 0.0
	initial_sound = true
	._Interrupt()

func play_sound_on_initialize() -> void:
	if initial_sound:
		.play_sound_on_initialize()

func _EndCondition() -> bool:
	if pressing_towards_wall() or character.is_on_floor():
		return true
	return false

	
