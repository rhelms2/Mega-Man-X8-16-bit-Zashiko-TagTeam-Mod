extends VileAirCannon


func play_animation(anim: String):
	if is_player_above() and "flight_cannon" in anim:
		anim += "2"
	.play_animation(anim)
	current_animation = anim

func play_animation_again(anim: String):
	if is_player_above() and "flight_cannon" in anim:
		anim += "2"
	.play_animation(anim)
	current_animation = anim
	finished_animation = ""
