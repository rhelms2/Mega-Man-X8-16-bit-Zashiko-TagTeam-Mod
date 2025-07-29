extends AttackAbility

onready var laser_eye: Node2D = $"../animatedSprite/LaserEye"

var laser_attack_time: Array = [0.5, 0.5, 1.0]
var laser_duration: float = 0.75
var laser_time: Array = [0.5, 0.5]

func set_game_modes() -> void :
	if CharacterManager.game_mode <= - 1:
		laser_attack_time = [0.5, 0.5, 1.0]
		laser_duration = 1.2
		laser_time = [0.5, 0.5]
	if CharacterManager.game_mode == 0:
		laser_attack_time = [0.5, 0.5, 1.0]
		laser_duration = 0.75
		laser_time = [0.5, 0.5]
	if CharacterManager.game_mode == 1:
		laser_attack_time = [0.4, 0.4, 0.9]
		laser_duration = 0.65
		laser_time = [0.4, 0.4]
	if CharacterManager.game_mode == 2:
		laser_attack_time = [0.3, 0.3, 0.7]
		laser_duration = 0.55
		laser_time = [0.3, 0.3]
	if CharacterManager.game_mode >= 3:
		laser_attack_time = [0.1, 0.1, 0.5]
		laser_duration = 0.45
		laser_time = [0.1, 0.1]

func _Setup() -> void :
	set_game_modes()
	play_animation("laser_prepare")

func _Update(_delta: float) -> void :
	process_gravity(_delta)
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("laser_prepare_loop")
		next_attack_stage()

	elif attack_stage == 1 and timer > laser_attack_time[0]:
		activate_laser_eye()
		next_attack_stage()

	elif attack_stage == 2 and timer > laser_attack_time[1]:
		play_animation("laser")
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("laser_end_loop")
		next_attack_stage()

	elif attack_stage == 4 and timer > laser_attack_time[2]:
		play_animation("laser_end")
		laser_eye.deactivate()
		next_attack_stage()

	elif attack_stage == 5 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	laser_eye.deactivate()
	

func activate_laser_eye() -> void:
	laser_eye.rotation_order = Vector2(-230,-360)
	laser_eye.position.x = -5
	laser_eye.rotation_degrees = laser_eye.rotation_order[0]
	laser_eye.duration = laser_duration
	laser_eye.make_visible_and_activate_damage()
	Tools.timer(laser_time[0], "activate", laser_eye)
	Tools.timer(laser_time[1], "move_laser_eye", self)

func move_laser_eye() -> void:
	Tools.tween(laser_eye,"position:x",5,0.4)
		
