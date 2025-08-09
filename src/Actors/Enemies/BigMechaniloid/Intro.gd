extends AttackAbility

var finished := false
onready var land: AudioStreamPlayer2D = $land
onready var eye: AudioStreamPlayer2D = $eye

var deactivated_player := false

func _Setup() -> void:
	#set_direction(1)
	play_animation("fall")

func _Update(delta) -> void:
	if attack_stage == 0 and character.started_pursuit:
		animatedSprite.modulate = Color(1,1,1,1)
		process_gravity(delta)
		if GameManager.player and not deactivated_player:
			GameManager.player.cutscene_deactivate()
			deactivated_player = true
		if character.is_on_floor():
			land.play()
			play_animation("land")
			screenshake()
			GameManager.player.set_direction(-1)
			next_attack_stage()
	
	elif attack_stage == 1 and timer > 1:
		play_animation("ready")
		eye.play()
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 1:
		EndAbility()

func _Interrupt() -> void:
	finished = true
	GameManager.player.start_listening_to_inputs()
	
func _StartCondition() -> bool:
	return not finished
