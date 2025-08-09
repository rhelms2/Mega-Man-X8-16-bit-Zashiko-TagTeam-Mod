extends X8TextureButton

onready var parent: = get_parent()
export  var legible_name: String
export  var description: String
onready var name_display: Label = $"../../../../Description/name"
onready var disc_display: Label = $"../../../../Description/disc"
onready var equip: AudioStreamPlayer = $"../../../../../../../equip"
export  var part_texture = []

func _ready() -> void :
	texture_normal = part_texture[1]

func _on_focus_entered() -> void :
	play_sound()
	flash()

func _on_focus_exited() -> void :
	if name in parent.current_armor:
		return
	elif name in GameManager.equip_exceptions:
		return
	else:
		dim()

func on_press() -> void :
	for child in get_parent().get_children():
		if child is Node:
			child.show()
			
	self.hide()
	strong_flash()
	Tools.timer(0.075, "play", equip)

