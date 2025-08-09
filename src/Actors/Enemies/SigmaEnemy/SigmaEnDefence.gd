extends AttackAbility
onready var enemy_shield: Node2D = $"../EnemyShield"

var able_to_defend := true
var turning := false
signal unable_to_defend

func _StartCondition() -> bool:
	return able_to_defend

func _Setup() -> void:
	turning = false
	if not is_facing_player():
		play_animation("turn")
		turning = true
	
func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0:
		if turning: 
			if has_finished_last_animation():
				turn()
				play_animation("shield_prepare")
				next_attack_stage()
		else:
			play_animation("shield_prepare")
			next_attack_stage()

	elif attack_stage == 1 and has_finished_last_animation():
		enemy_shield.activate()
		play_animation("shield")
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 2:
		if not is_facing_player():
			enemy_shield.deactivate()
			play_animation("shield_end")
			make_unable_to_defend()
			next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()

func make_unable_to_defend() -> void:
	able_to_defend = false
	emit_signal("unable_to_defend")

func _on_EnemyStun_ability_start(_ability) -> void:
	make_unable_to_defend()
