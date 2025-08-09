extends ArtificialIntelligence

func respond_to_player_nearby(_delta: float):
	if current_action == last_action:
		if target_to_the_right():
			if character.get_facing_direction() != 1:
				artificial_input("go_right")
		elif target_to_the_left():
			if character.get_facing_direction() != -1:
				artificial_input("go_left")
	if current_action == last_action:
		artificial_input("attack") 

func action_for_no_nearby_player(delta: float):
	turn_randomly(delta)

func turn_randomly(delta: float):
	timer += delta
	if timer > 2:
		timer = 0
		if current_action == last_action:
			if rand_range(0,1) > 0.5:
				if character.get_facing_direction() != 1:
					artificial_input("go_right")
			else:
				if character.get_facing_direction() != -1:
					artificial_input("go_left")
