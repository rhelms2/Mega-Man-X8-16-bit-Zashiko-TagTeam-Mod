extends X8TextureButton

export  var pick_sound: NodePath
export  var able_to_unlock_debug: bool = false

onready var sub_menu = get_child(0)


func _ready() -> void :
	var _s = sub_menu.connect("end", self, "_on_submenu_end")

func on_press() -> void :
	get_node(pick_sound).play()
	menu.lock_buttons()
	strong_flash()
	sub_menu.start()

func _on_submenu_end() -> void :
	menu.unlock_buttons()
	grab_focus()
