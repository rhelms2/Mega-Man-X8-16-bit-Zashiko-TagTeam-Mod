extends ConfirmButton

export  var post_confirm: String


func _ready() -> void :
	pass

func on_press() -> void :
	times_pressed += 1
	if times_pressed == 1:
		if not flashed:
			strong_flash()
			flashed = true
			menu.play_equip_sound()
		text.text = confirmation
	if times_pressed == 2:
		menu.play_cancel_sound()
		strong_flash()
		action()
		text.text = post_confirm

func action() -> void :
	Achievements.reset_all()
