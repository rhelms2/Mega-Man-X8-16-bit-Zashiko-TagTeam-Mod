extends Spawner

func should_spawn() -> bool:
	return not visibility.is_on_screen() and GameManager.is_player_nearby(self) \
	and not GameManager.player.is_executing("Ride") and not GameManager.is_bike_nearby(self)

func should_despawn() -> bool:
	if has_spawned:
		if GameManager.player != null: #avoiding reset level bug
			if GameManager.player.is_executing("Ride") and not spawned_object.is_executing("Riden"):
				return true
	return false

func despawn() -> void:
	.despawn()
