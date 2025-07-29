extends EnemyDeath


func get_spawn_item():
	if CharacterManager.game_mode < 0:
		return GameManager.get_next_spawn_item(100, 5, 25, 30, 30, 10)
	elif CharacterManager.game_mode == 0:
		return GameManager.get_next_spawn_item(85, 5, 5, 30, 50, 0.1)
	elif CharacterManager.game_mode == 1:
		return GameManager.get_next_spawn_item(65, 5, 5, 30, 50, 0.1)
	elif CharacterManager.game_mode == 2:
		return GameManager.get_next_spawn_item(40, 5, 5, 30, 50, 0)
	elif CharacterManager.game_mode >= 3:
		return GameManager.get_next_spawn_item(0, 0, 0, 0, 0, 0)

func _on_EnemyDeath_ability_start(_ability) -> void :
	character.set_collision_mask_bit(0, false)
	character.set_collision_mask_bit(9, false)
	pass
