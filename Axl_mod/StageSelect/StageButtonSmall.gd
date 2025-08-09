extends X8TextureButton

onready var icon = $animatedSprite
onready var pointer: AnimatedSprite = $"../../../map/pointer"

export  var stage_info: Resource
export  var frame: = 0
export  var intensity: = 0

signal stage_selected(info)
signal moved_cursor(pos)

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

func _ready() -> void :
	emit_signal("stage_selected", stage_info)

func _on_focus_entered() -> void :
	play_sound()
	flash()
	icon.animation = "idle"
	emit_signal("stage_selected", stage_info)
	
	emit_signal("moved_cursor", stage_info.pointer_position)

func _on_focus_exited() -> void :
	dim()
	icon.animation = "blink"

func on_press() -> void :
	CharacterManager.NO_MOVEMENT_CHALLENGE = false
	CharacterManager.teleport_to_boss = false
	get_node(menu_path).picked_stage(stage_info)
