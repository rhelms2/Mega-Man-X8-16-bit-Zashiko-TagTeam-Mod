extends BackgroundSwapper

export  var extra_bgs_to_activate: Array

var backgrounds_to_activate: Array


func _ready() -> void :
	for bg_path in extra_bgs_to_activate:
		backgrounds_to_activate.append(get_node(bg_path))

func activate_bg() -> void :
	bg_to_activate.visible = true
	for bg in backgrounds_to_activate:
		bg.visible = true
