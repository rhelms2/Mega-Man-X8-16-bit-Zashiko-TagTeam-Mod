extends X8TextureButton

export  var legible_name: String
export  var description: String

onready var parent: HBoxContainer = get_parent()
onready var name_display: Label = $"../../../../../../Description/name"
onready var disc_display: Label = $"../../../../../../Description/disc"
onready var equip: AudioStreamPlayer = $"../../../../../../../equip"
onready var dark_bg: Sprite = $sprite
onready var main_color: TextureRect = $"../../../../Armor/ultima_main"
onready var main_color_head: TextureRect = $"../../../../Armor/base_u"

onready var grandparent: VBoxContainer = parent.get_parent()
onready var headparts: HBoxContainer = grandparent.get_node("HeadParts")
onready var bodyparts: HBoxContainer = grandparent.get_node("BodyParts")
onready var armsparts: HBoxContainer = grandparent.get_node("ArmsParts")
onready var legsparts: HBoxContainer = grandparent.get_node("LegsParts")
onready var parts = {
	"head": {
		"default": headparts.get_node("head"), 
		"ultimate": headparts.get_node("ultima_head"), 
		"node": headparts, 
	}, 
	"body": {
		"default": bodyparts.get_node("body"), 
		"ultimate": bodyparts.get_node("ultima_body"), 
		"node": bodyparts, 
	}, 
	"arms": {
		"default": armsparts.get_node("arms"), 
		"ultimate": armsparts.get_node("ultima_arms"), 
		"node": armsparts, 
	}, 
	"legs": {
		"default": legsparts.get_node("legs"), 
		"ultimate": legsparts.get_node("ultima_legs"), 
		"node": legsparts, 
	}, 
}
func equip_full_ultimate() -> void :
	Event.emit_signal("full_set")
	CharacterManager.ultimate_x_armor = true
	for part_name in parts.keys():
		var p = parts[part_name]
		GameManager.remove_equip_exception(part_name)
		GameManager.reposition_collectible_in_savedata(p["ultimate"].name)
		p["ultimate"].strong_flash()
		p["node"].equip(p["ultimate"])

func unequip_full_ultimate() -> void :
	Event.emit_signal("mixed_set")
	CharacterManager.ultimate_x_armor = false
	for part_name in parts.keys():
		var p = parts[part_name]
		GameManager.add_equip_exception(part_name)
		p["default"].strong_flash()
		p["node"].equip(p["default"])

func is_ultimate_equipped() -> bool:
	for part in parent.current_armor:
		if "ultima" in part:
			return true
	return false

func _on_focus_entered() -> void :
	play_sound()
	display_info()
	flash()
	dark_bg.visible = false

func _on_focus_exited() -> void :
	dark_bg.visible = true
	main_color.visible = CharacterManager.ultimate_x_armor
	main_color_head.visible = CharacterManager.ultimate_x_armor
	if name in parent.current_armor:
		return
	elif name in GameManager.equip_exceptions and not CharacterManager.ultimate_x_armor:
		return
	else:
		dim()

func on_press() -> void :
	if "ultima" in name:
		if not CharacterManager.ultimate_x_armor:
			equip_full_ultimate()
	else:
		if CharacterManager.ultimate_x_armor and is_ultimate_equipped():
			unequip_full_ultimate()

	if not is_viable_armor(name):
		GameManager.add_equip_exception(name)
	else:
		GameManager.remove_equip_exception(get_body_part_name(name))
		GameManager.reposition_collectible_in_savedata(name)
	main_color.visible = CharacterManager.ultimate_x_armor
	main_color_head.visible = CharacterManager.ultimate_x_armor
	strong_flash()
	Tools.timer(0.075, "play", equip)
	parent.equip(self)

func is_viable_armor(armor_name: String) -> bool:
	return "icarus" in armor_name or "hermes" in armor_name or "ultima" in armor_name

func get_body_part_name(collectible_name: String) -> String:
	return collectible_name.substr(7)

func display_info() -> void :
	name_display.text = tr(legible_name)
	disc_display.text = tr(description)

func visually_unequip_items() -> void :
	pass
