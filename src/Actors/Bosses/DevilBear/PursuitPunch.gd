extends AttackAbility
onready var punch_sfx: AudioStreamPlayer2D = $"../punch"
onready var jump_sound: AudioStreamPlayer2D = $"../jump_sound"
onready var step: AudioStreamPlayer2D = $"../step"
onready var anim := AnimationController.new($"../animatedSprite")
onready var land: Particles2D = $"../land"
onready var wind: Sprite = $"../animatedSprite/wind"
onready var punch_collider: Node2D = $punch

func _Setup() -> void:
	turn_and_face_player()

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		if is_player_nearby_horizontally(64) and not is_player_above():
			next_attack_stage()
		else:
			go_to_attack_stage(3)
	
	elif attack_stage == 1:
		play_animation_once("jump")
		jump_sound.play_rp()
		force_movement(-horizontal_velocity)
		set_vertical_speed(-jump_velocity)
		next_attack_stage()
	
	elif attack_stage == 2:
		if get_vertical_speed() > 0:
			play_animation_once("fall")
		if timer > 0.1 and character.is_on_floor():
			screenshake(0.7)
			step.play()
			land.emitting = true
			turn_and_face_player()
			next_attack_stage_on_next_frame()
	
	elif attack_stage == 3:
		play_animation_once("walk")
		force_movement(horizontal_velocity)
		next_attack_stage()
	
	elif attack_stage == 4:
		play_steps_sounds()
		if is_player_nearby_horizontally(48) or timer > 2:
			punch_collider.handle_direction()
			play_animation("punch_1")
			wind.emit()
			punch_sfx.play_rp()
			decay_speed()
			Tools.timer(0.05,"punch",self)
			next_attack_stage()
	
	elif attack_stage == 5 and timer > 0.25:
		play_animation("punch_end")
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.25:
		EndAbility()


func punch():
	punch_collider.activate()
	pass

var sound_played := false

func play_steps_sounds() -> void:
	if anim.is_between(1,1) or anim.is_between(6,6):
		if not sound_played:
			step.play_rp(0.06)
			sound_played = true
	else:
		sound_played = false
