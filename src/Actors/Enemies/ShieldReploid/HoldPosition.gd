extends AttackAbility

func _Setup() -> void:
	attack_stage = 0

func _ready() -> void:
	character.listen("shield_hit",self,"extend_duration")

func extend_duration() -> void:
	play_animation("deflect")
	timer = 0

func _Update(_delta) -> void:
	if attack_stage == 0 and has_finished_last_animation():
		next_attack_stage_on_next_frame()
	elif attack_stage == 1 and timer > 1:
		EndAbility()
