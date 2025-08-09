extends EnemyDeath


func get_spawn_item():
	if CharacterManager.game_mode < 0:
		return GameManager.get_next_spawn_item(100, 0, 0, 0, 0, 100)
	elif CharacterManager.game_mode == 0:
		return GameManager.get_next_spawn_item(100, 0, 0, 0, 0, 100)
	elif CharacterManager.game_mode == 1:
		return GameManager.get_next_spawn_item(75, 0, 0, 0, 0, 100)
	elif CharacterManager.game_mode == 2:
		return GameManager.get_next_spawn_item(50, 0, 50, 0, 50, 0)
	elif CharacterManager.game_mode >= 3:
		return GameManager.get_next_spawn_item(0, 0, 0, 0, 0, 0)
