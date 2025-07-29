extends AttackAbility

onready var actual_attack: Node2D = $"../animatedSprite/smash_attack"
onready var stomp: AudioStreamPlayer2D = $stomp

var smash_time: Array = [0.85, 1.0]


func set_game_modes() -> void :
	if CharacterManager.game_mode <= - 1:
		smash_time = [0.85, 1.0]
	if CharacterManager.game_mode == 0:
		smash_time = [0.85, 1.0]
	if CharacterManager.game_mode == 1:
		smash_time = [0.7, 0.8]
	if CharacterManager.game_mode == 2:
		smash_time = [0.5, 0.6]
	if CharacterManager.game_mode >= 3:
		smash_time = [0.4, 0.3]

func _Setup() -> void :
	set_game_modes()
	play_animation("smash_prepare")
	set_direction( - get_facing_direction())

func _Update(_delta: float) -> void :
	process_gravity(_delta)
	
	if attack_stage == 0 and timer > smash_time[0]:
		play_animation("smash_start")
		next_attack_stage()

	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("smash")
		stomp.play()
		screenshake(2)
		actual_attack.activate()
		next_attack_stage()

	elif attack_stage == 2 and timer > smash_time[1]:
		play_animation("smash_end")
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()
