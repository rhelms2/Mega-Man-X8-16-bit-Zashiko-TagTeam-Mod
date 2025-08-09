extends PickUp

export  var ammo: int = 8

var amount_to_ammo: int = 8
var player_weapon


func _ready() -> void :
	amount_to_ammo = ammo

func on_rotate_stage() -> void :
	queue_free()

func process_effect(delta: float) -> void :
	if executing:
		timer += delta
		if player.get_node("Shot").current_weapon != null:
			
			player_weapon = player.get_node("Shot").current_weapon
			if player_weapon.current_ammo < player_weapon.max_ammo:
				do_ammo(player_weapon)
			else:
				if amount_to_ammo > 0:
					add_ammo_to_reserve()
			if amount_to_ammo == 0:
				timer = 0
				GameManager.unpause(name)
				amount_to_ammo = - 1
				if not $audioStreamPlayer2D.playing:
					queue_free()
		else:
			GameManager.unpause(name)
			queue_free()

func do_ammo(p_weapon) -> void :
	if timer > last_time_increased + 0.06 and amount_to_ammo > 0:
		p_weapon.current_ammo += 1
		p_weapon.current_ammo = clamp(p_weapon.current_ammo, 0, p_weapon.max_ammo)
		last_time_increased = timer
		amount_to_ammo -= 1
		$audioStreamPlayer2D.play()

func add_ammo_to_reserve() -> void :
	Event.emit_signal("add_to_ammo_reserve", amount_to_ammo)
	amount_to_ammo = 0
