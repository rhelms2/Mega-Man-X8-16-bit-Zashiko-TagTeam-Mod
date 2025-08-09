extends AttackAbility
onready var smoke_creator: Node = $SmokeCreator

func _Update(_delta):
	if attack_stage == 0 and timer > .5:
		play_animation("swipe")
		smoke_creator.activate()
		Tools.timer(3,"deactivate",smoke_creator)
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 1.0:
		play_animation("swipe_end")
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

