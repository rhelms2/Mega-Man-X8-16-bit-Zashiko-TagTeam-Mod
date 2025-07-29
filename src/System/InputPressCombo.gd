extends Resource
class_name InputPressCombo

export  var inputs: Array
export  var leeway: float


func _init(_inputs: Array, _leeway: float) -> void :
	inputs = _inputs
	leeway = _leeway
	pass

func matches(p_inputs: Array, p_timings: Array, p_leeway: = leeway) -> bool:
	if p_inputs.size() < inputs.size():
		return false
	var player_inputs = get_last_elements(p_inputs)
	var player_timings = get_last_elements(p_timings)
	if player_is_facing_back():
		player_inputs = mirror_inputs(player_inputs)
	return input_matches(player_inputs) and timing_matches(player_timings, p_leeway)

func player_is_facing_back() -> bool:
	if GameManager.is_player_in_scene():
		return GameManager.player.get_facing_direction() == - 1
	return false

func mirror_inputs(player_inputs) -> Array:
	var mirror_inputs = []
	for input in player_inputs:
		mirror_inputs.append(Tools.flip_input(input))
	return mirror_inputs

func input_matches(player_inputs) -> bool:
	var i = 0
	for input in inputs:
		if input != player_inputs[i]:
			return false
		i += 1
	return true

func timing_matches(player_timings, _leeway) -> bool:
	var i = 0
	for timing in player_timings:
		if i == player_timings.size() - 1:
			pass
		else:
			if player_timings[i + 1] - timing > _leeway:
				return false
		i += 1
	return true

func get_last_elements(p_inputs) -> Array:
	var player_inputs = []
	var i = 0
	while player_inputs.size() < inputs.size():
		player_inputs.append(p_inputs[(p_inputs.size()) - inputs.size() + i])
		i += 1
	return player_inputs
