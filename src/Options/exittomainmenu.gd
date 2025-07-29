extends ConfirmButton

export  var main_menu_path: String = "../../../../../../../../"

onready var main_menu = get_node_or_null(main_menu_path)


func _ready() -> void :
	if main_menu:
		if main_menu.name == "MainMenu":
			self.visible = false

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

func action() -> void :
	GameManager.go_to_intro()
