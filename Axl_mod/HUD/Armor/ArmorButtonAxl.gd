extends X8TextureButton

export  var legible_name: String
export  var description: String

onready var parent: = get_parent()
onready var name_display: Label = $"../../../../../../Description/name"
onready var disc_display: Label = $"../../../../../../Description/disc"
onready var equip: AudioStreamPlayer = $"../../../../../../../equip"
onready var dark_bg: Sprite = $sprite

onready var base_white: TextureRect = $"../../../../Armor/base_W"

onready var part_types: = ["HeadParts", "BodyParts", "ArmParts", "LegParts"]
onready var part_nodes: = {
	"HeadParts": get_part_node("HeadParts"), 
	"BodyParts": get_part_node("BodyParts"), 
	"ArmParts": get_part_node("ArmParts"), 
	"LegParts": get_part_node("LegParts"), 
}
onready var default_parts: = get_parts_by_name("head", "body", "arms", "legs")
onready var white_parts: = get_parts_by_name("white_head", "white_body", "white_arms", "white_legs")

func get_part_node(name: String) -> Node:
	return get_parent().get_parent().get_node(name)

func get_parts_by_name(h: String, b: String, a: String, l: String) -> Dictionary:
	return {
		"HeadParts": part_nodes["HeadParts"].get_node(h), 
		"BodyParts": part_nodes["BodyParts"].get_node(b), 
		"ArmParts": part_nodes["ArmParts"].get_node(a), 
		"LegParts": part_nodes["LegParts"].get_node(l), 
	}

func equip_parts(parts: Dictionary) -> void :
	for part_type in part_types:
		var node = parts[part_type]
		node.strong_flash()
		part_nodes[part_type].equip(node)

func equip_white_axl() -> void :
	equip_parts(white_parts)
	CharacterManager.white_axl_armor = true

func unequip_white_axl() -> void :
	equip_parts(default_parts)
	CharacterManager.white_axl_armor = false

func _on_focus_entered() -> void :
	play_sound()
	display_info()
	flash()
	dark_bg.visible = false

func _on_focus_exited() -> void :
	dark_bg.visible = true
	base_white.visible = CharacterManager.white_axl_armor
	var blocked_names: = ["head", "body", "arms", "legs"]
	if ("white" in name and CharacterManager.white_axl_armor) or \
	( not CharacterManager.white_axl_armor and name in blocked_names):
		return
	dim()

func is_white_armor_equipped() -> bool:
	for part in parent.current_armor:
		if "white" in part:
			return true
	return false

func on_press() -> void :
	if "white" in name:
		if not CharacterManager.white_axl_armor:
			equip_white_axl()
	else:
		if CharacterManager.white_axl_armor:
			unequip_white_axl()

	base_white.visible = CharacterManager.white_axl_armor
	strong_flash()
	Tools.timer(0.075, "play", equip)
	parent.equip(self)

func display_info() -> void :
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)

func visually_unequip_items() -> void :
	pass
