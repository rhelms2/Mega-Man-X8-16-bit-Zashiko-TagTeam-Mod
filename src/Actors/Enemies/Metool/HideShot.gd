extends MetoolHide


func _StartCondition() -> bool:
	return not is_player_looking_away()
