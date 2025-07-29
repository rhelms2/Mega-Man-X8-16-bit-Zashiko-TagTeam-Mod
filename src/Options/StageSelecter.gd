extends X8TextureButton

func on_press() -> void :
	$"../../../pick".play()
	$"../../../Song".fade_out()
	var menu = get_node(menu_path)
	menu.lock_buttons()
	menu.fader.SoftFadeOut()
	strong_flash()
	yield(menu.fader, "finished")
	GameManager.start_level(name)
