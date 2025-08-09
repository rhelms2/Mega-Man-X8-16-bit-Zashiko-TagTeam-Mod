extends AttackAbility

var attack_duration := 0.75
var time_to_return := 0.25
onready var tween = TweenController.new(self)
onready var space: Node = $"../Space"
onready var spin: AudioStreamPlayer2D = $spin
onready var land: AudioStreamPlayer2D = $land
onready var move: AudioStreamPlayer2D = $"../move"

signal stop

func _Setup() -> void:
	turn_and_face_player()
	go_to_closest_position()
	play_animation("roll_prepare")

func _Update(delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("roll_start")
		spin.play()
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("roll_loop")
		next_attack_stage()
	
	elif attack_stage == 2:
		first_jump_on_player()
		next_attack_stage()

	elif attack_stage == 3:
		process_gravity(delta)
		if reached_bottom():
			land.play_rp()
			spin.play()
			screenshake()
			next_attack_stage()
	
	elif attack_stage == 4:
		second_jump_on_player()
		next_attack_stage()
	
	elif attack_stage == 5:
		process_gravity(delta)
		if reached_bottom():
			land.play_rp()
			screenshake()
			turn_and_face_player()
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 6:
		tween.create(Tween.EASE_OUT,Tween.TRANS_CUBIC,true)
		tween.add_method("set_vertical_speed",-jump_velocity*1.25,0.0,attack_duration)
		tween.add_attribute("global_position:x",global_position.x + (32 * -get_facing_direction()),attack_duration/2,character)
		next_attack_stage()
	
	elif attack_stage == 7:
		play_animation_once("roll_end")
		if timer > attack_duration/2:
			go_to_closest_position()
			next_attack_stage()
	
	elif attack_stage == 8:
		turn_and_face_player()
		if has_finished_animation("roll_end"):
			play_animation_once("move_down")
		if timer > time_to_return:
			EndAbility()

func go_to_closest_position() -> void:
	var pos = space.get_closest_position()
	time_to_return = space.time_to_position(pos)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position",pos,time_to_return,character)

func reached_bottom() -> bool:
	return character.is_on_floor() and timer > 0.25 or global_position.y > space.get_platform() and timer > 0.25 

func first_jump_on_player() -> void:
	tween.reset()
	tween.create()
	tween.set_parallel()
	tween.add_method("set_vertical_speed",-jump_velocity,0.0,attack_duration/2)
	tween.get_last().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.add_attribute("global_position:x",get_player_position_x(),attack_duration,character)

func second_jump_on_player() -> void:
	tween.create()
	tween.set_parallel()
	tween.add_method("set_vertical_speed",-jump_velocity * 1.75,0.0,attack_duration/2)
	tween.get_last().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.add_attribute("global_position:x",get_player_position_x(),attack_duration,character)

func get_player_position_x() -> float:
	return GameManager.get_player_position().x

func _Interrupt() -> void:
	emit_signal("stop")
