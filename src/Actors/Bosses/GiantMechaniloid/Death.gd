extends EnemyDeath

func extra_actions_after_death() -> void :
	Event.emit_signal("miniboss_kill")

func get_spawn_item():
	if CharacterManager.game_mode < 0:
		return GameManager.get_next_spawn_item(100, 0, 0, 0, 0, 100)
	elif CharacterManager.game_mode == 0:
		return GameManager.get_next_spawn_item(100, 0, 0, 0, 0, 100)
	elif CharacterManager.game_mode == 1:
		return GameManager.get_next_spawn_item(75, 0, 0, 0, 0, 100)
	elif CharacterManager.game_mode == 2:
		return GameManager.get_next_spawn_item(50, 0, 50, 0, 50, 0)
	else:
		return GameManager.get_next_spawn_item(0, 0, 0, 0, 0, 0)
