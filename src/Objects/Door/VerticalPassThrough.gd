extends DoorPassThrough


func _Setup() -> void :
	player = GameManager.player
	player.force_movement()
	player.disable_collision()
	if should_freeze_player_animation():
		freeze_player_animation()
	move_vertically()

func move_vertically() -> void :
	tween.attribute("global_position:y", get_final_position(), 1.75, player)

func _Update(_delta: float) -> void :
	pass

func has_passed_through() -> bool:
	return timer > 1.75

func get_final_position() -> float:
	return global_position.y + (travel_distance * 2)

func _Interrupt() -> void :
	player.set_y(get_final_position())
	player.enable_collision()
	Tools.timer_p(0.02, "set_vertical_speed", player, - 50.0)
	player.set_direction(1)
	unfreeze_player_animation()
