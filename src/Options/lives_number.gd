extends Label

func _on_pause_starting() -> void :
	if not GlobalVariables.exists("player_lives"):
		GlobalVariables.set("player_lives", 2)
	text = str(GlobalVariables.get("player_lives"))
		
