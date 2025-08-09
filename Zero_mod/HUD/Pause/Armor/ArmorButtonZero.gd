extends X8TextureButton

export  var legible_name: String
export  var description: String

onready var parent: = get_parent()
onready var name_display: Label = $"../../../../../../Description/name"
onready var disc_display: Label = $"../../../../../../Description/disc"
onready var equip: AudioStreamPlayer = $"../../../../../../../equip"
onready var dark_bg: Sprite = $sprite

onready var base_black: TextureRect = $"../../../../Armor/base_B"

onready var part_types: = ["HeadParts", "BodyParts", "ArmParts", "LegParts"]
onready var part_nodes: = {
	"HeadParts": get_part_node("HeadParts"), 
	"BodyParts": get_part_node("BodyParts"), 
	"ArmParts": get_part_node("ArmParts"), 
	"LegParts": get_part_node("LegParts"), 
}
onready var default_parts: = get_parts_by_name("head", "body", "arms", "legs")
onready var black_parts: = get_parts_by_name("black_head", "black_body", "black_arms", "black_legs")

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

func equip_black_zero() -> void :
	equip_parts(black_parts)
	CharacterManager.black_zero_armor = true

func unequip_black_zero() -> void :
	equip_parts(default_parts)
	CharacterManager.black_zero_armor = false

func _on_focus_entered() -> void :
	play_sound()
	display_info()
	flash()
	dark_bg.visible = false

func _on_focus_exited() -> void :
	base_black.visible = CharacterManager.black_zero_armor
	dark_bg.visible = true
	var blocked_names: = ["head", "body", "arms", "legs"]
	if ("black" in name and CharacterManager.black_zero_armor) or \
	( not CharacterManager.black_zero_armor and name in blocked_names):
		return
	dim()

func is_black_armor_equipped() -> bool:
	for part in parent.current_armor:
		if "black" in part:
			return true
	return false

func on_press() -> void :
	if "black" in name:
		if not CharacterManager.black_zero_armor:
			equip_black_zero()
	else:
		if CharacterManager.black_zero_armor:
			unequip_black_zero()

	base_black.visible = CharacterManager.black_zero_armor
	strong_flash()
	Tools.timer(0.075, "play", equip)
	parent.equip(self)

func display_info() -> void :
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)

func visually_unequip_items() -> void :
	pass
