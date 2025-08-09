extends AttackAbility

onready var tween := TweenController.new(self,false)
onready var jump_sound: AudioStreamPlayer2D = $"../jump_sound"
onready var step: AudioStreamPlayer2D = $"../step"
onready var rise: AudioStreamPlayer2D = $"../rise"
onready var land: Particles2D = $"../land"

func _Setup() -> void:
	turn_and_face_player()

func _Update(delta) -> void:
	if attack_stage == 0:
		play_animation("jump")
		land.restart()
		jump_sound.play()
		set_vertical_speed(-jump_velocity)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation("jump_loop")
		rise.play()
		turn_and_face_player()
		set_vertical_speed(-jump_velocity/3)
		accelerate_horizontally()
		next_attack_stage()
	
	elif attack_stage == 2:
		if should_fall() or timer > 2:
			play_animation("fall")
			tween.reset()
			decay_speed()
			set_vertical_speed(40)
			next_attack_stage()
	
	elif attack_stage == 3:
		process_gravity(delta)
		if character.is_on_floor():
			step.play()
			land.restart()
			screenshake()
			play_animation("recover")
			next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	tween.reset()

func should_fall() -> bool:
	return is_player_nearby_horizontally(24) and not is_player_above() or not is_player_in_front() 

func accelerate_horizontally():
	tween.method("set_horizontal_speed",0,horizontal_velocity* 5 * get_player_direction_relative(),2)
