extends X8TextureButton

export  var stage_info: Resource
export  var frame: int = 0
export  var intensity: int = 0

signal stage_selected(info)


func _input(event: InputEvent) -> void :
	if has_focus():
		if event.is_action_pressed("fire"):
			if stage_info.was_beaten():
				CharacterManager.NO_MOVEMENT_CHALLENGE = false
				CharacterManager.teleport_to_boss = false
				get_node(menu_path).picked_stage(stage_info)
		if event.is_action_pressed("alt_fire"):
			if stage_info.was_beaten():
				CharacterManager.NO_MOVEMENT_CHALLENGE = false
				CharacterManager.teleport_to_boss = true
				get_node(menu_path).picked_stage(stage_info)
		if event.is_action_pressed("select_special"):
			if stage_info.was_beaten():
				CharacterManager.NO_MOVEMENT_CHALLENGE = true
				CharacterManager.teleport_to_boss = false
				get_node(menu_path).picked_stage(stage_info)

func _on_focus_entered() -> void :
	play_sound()
	emit_signal("stage_selected", stage_info)

func on_press() -> void :
	CharacterManager.NO_MOVEMENT_CHALLENGE = false
	CharacterManager.teleport_to_boss = false
	get_node(menu_path).picked_stage(stage_info)
