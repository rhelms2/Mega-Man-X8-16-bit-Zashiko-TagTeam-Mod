extends Node

export  var subtanks: Array


func _ready() -> void :
	clear_weapon_get_data()
	fill_unlocked_subtanks()
	turn_off_lights_for_pitch_black()
	reset_gateway_if_defeated_copy_sigma()
	add_finished_intro_to_savedata()
	Tools.timer(0.1, "unlock_achievement_all_weapons", self)

func unlock_achievement_all_weapons():
	var unlocked_weapons = 0
	for item in GameManager.collectibles:
		if "_weapon" in item and not "boss_weapon" in item:
			unlocked_weapons += 1
	if unlocked_weapons >= 8:
		Achievements.unlock("DEFEATEDALL")

func fill_unlocked_subtanks() -> void :
	for subtank in subtanks:
		if GlobalVariables.get(subtank.id) != null:
			GlobalVariables.set(subtank.id, subtank.capacity)

func turn_off_lights_for_pitch_black() -> void :
	GlobalVariables.set("pitch_black_energized", false)

func clear_weapon_get_data() -> void :
	GameManager.finish_weapon_get()

func reset_gateway_if_defeated_copy_sigma() -> void :
	if GatewayManager.has_defeated_copy_sigma():
		GatewayManager.soft_reset()

func add_finished_intro_to_savedata() -> void :
	GameManager.add_collectible_to_savedata("finished_intro")
