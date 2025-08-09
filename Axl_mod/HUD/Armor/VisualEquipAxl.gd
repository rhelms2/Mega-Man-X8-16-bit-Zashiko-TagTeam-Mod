extends HBoxContainer

onready var part_options: = get_children()
onready var white_part = part_options[1]
onready var default_part = part_options[0]
onready var armor: Control = $"../../../Armor"
onready var tween: = TweenController.new(self, false)
onready var menu: CanvasLayer = $"../../../../../.."

var current_armor: Array = ["head", "body", "arms", "legs"]


func _ready() -> void :
	var _s = menu.connect("initialize", self, "initialize")

func initialize() -> void :
	show_parts()
	for part in part_options:
		part._on_focus_exited()

func show_parts() -> void :
	for part in part_options:
		part.visible = "white_axl_armor" in GameManager.collectibles
		if part.visible:
			part.modulate = Color.dimgray
			if "white" in part.name and CharacterManager.white_axl_armor or not "white" in part.name and not CharacterManager.white_axl_armor:
				part.modulate = Color.white
				equip(part)
	default_part.visible = true

func black_body_unlocked():
	return "white_axl_armor" in GameManager.collectibles

func equip(part: X8TextureButton) -> void :
	for option in part_options:
		if option != part:
			option.dim()
	visual_armor_unequip(get_body_part_name(part.name))
	visual_armor_equip(part.name)

func visual_armor_equip(part_name: String, reset: bool = true) -> void :
	if reset:
		tween.end()
		tween.reset()
	var piece: TextureRect = armor.get_node(part_name)
	var original_y: = piece.rect_position.y
	var duration: = 0.15
	piece.visible = true
	piece.rect_position.y -= 7
	piece.modulate.a = 0.0
	tween.create(Tween.EASE_IN, Tween.TRANS_QUAD, true)
	tween.add_attribute("modulate:a", 1.0, duration, piece)
	tween.add_attribute("rect_position:y", original_y + 3, duration, piece)
	tween.set_sequential()
	tween.add_callback("flash", self, [piece])
	tween.add_attribute("rect_position:y", original_y - 1, 0.06, piece)
	tween.add_attribute("rect_position:y", original_y, 0.06, piece)

func visual_armor_unequip(body_area: String) -> void :
	for kids in armor.get_children():
		if body_area in kids.name:
			kids.visible = false

func flash(piece: TextureRect) -> void :
	piece.modulate = Color(5, 5, 5, 1)
	tween.create(Tween.EASE_OUT, Tween.TRANS_CUBIC, true)
	tween.add_attribute("modulate", Color.white, 0.3, piece)

func is_armor(armor_name: String) -> bool:
	return "white" in armor_name

func get_body_part_name(collectible_name: String) -> String:
	if collectible_name.length() <= 4:
		return collectible_name
	return collectible_name.substr(6)

func is_in_exceptions(armor_name: String) -> bool:
	if get_body_part_name(armor_name) in GameManager.equip_exceptions:
		return true
	return false
