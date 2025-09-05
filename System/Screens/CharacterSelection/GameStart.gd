extends X8TextureButton

export  var pick_sound: NodePath

var char_name: String = ""
var can_start_game: bool = false


func set_player() -> void :
	CharacterManager.set_player_character(char_name)
	IGT.reset_rta()
	IGT.should_run_rta = true

func on_press() -> void :
	if can_start_game:
		CharacterManager.started_fresh_game = true
		set_player()
		if CharacterManager.player_character == "Zero" and CharacterManager.team.size() == 1:
			CharacterManager.only_zero = true
		get_node(pick_sound).play()
		Event.emit_signal("fadeout_startmenu")
		strong_flash()
		menu.lock_buttons()
		menu.fader.duration = 0.0625
		menu.fader.SoftFadeOut()
		yield(menu.fader, "finished")
		GameManager.seen_dialogues.clear()
		go_to_next_scene()

func go_to_next_scene() -> void :
	GameManager.start_level("NoahsPark")

func already_finished_noahs_park() -> bool:
	return "finished_intro" in GameManager.collectibles
