extends BossWeapon

var current_shield: Node

func fire(charge_level) -> void :
	if charge_level >= 3:
		Log("Firing Charged Shot")
		reduce_charged_ammo()
		fire_charged()
		last_fired_shot_was_charged = true
	else:
		Log("Firing Regular Shot")
		reduce_regular_ammo()
		fire_regular()
		start_cooldown()
		last_fired_shot_was_charged = false

func is_cooling_down() -> bool:
	return timer > 0

func fire_regular() -> void :
	play(weapon.sound)
	if is_instance_valid(current_shield):
		current_shield.expire()
	current_shield = instantiate_projectile(weapon.regular_shot)
	set_position_as_shot_position(current_shield)

func fire_charged() -> void :
	
	var shot = instantiate_projectile(weapon.charged_shot)
	set_position_as_shot_position(shot)
