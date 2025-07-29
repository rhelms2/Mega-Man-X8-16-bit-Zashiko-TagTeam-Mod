extends HBoxContainer

onready var part_options: = get_children()
onready var default_part = part_options[0]
onready var armor: Control = $"../../../Armor"
onready var tween: TweenController = TweenController.new(self, false)
onready var menu: CanvasLayer = $"../../../../../.."

var current_armor: Array

signal unlocked_hermes
signal unlocked_icarus
signal unlocked_ultimate


func _ready() -> void :
	var _s = menu.connect("initialize", self, "initialize")

func initialize() -> void :
	emit_unlocked_set_signals()
	show_parts()
	update_current_armor()
	for part in part_options:
		part._on_focus_exited()

func show_parts() -> void :
	align()
	for part in part_options:
		part.visible = part.name in GameManager.collectibles
		if part.visible:
			part.modulate = Color.dimgray
			align(part.name)
			update_current_armor()
			if part.name in current_armor:
				part.modulate = Color.white
				equip(part)
	default_part.visible = true

func update_current_armor() -> void :
	var all_armor_pieces: = get_collected_armor_pieces()
	current_armor = filter_parts(all_armor_pieces)
	emit_current_set_signals()
	if current_armor.size() != 4:
		CharacterManager.ultimate_x_armor = false
		return
	var seen_parts: = {}
	for armor in current_armor:
		if not armor.begins_with("ultima"):
			CharacterManager.ultimate_x_armor = false
			return
		var part: = get_body_part_name(armor)
		if seen_parts.has(part):
			CharacterManager.ultimate_x_armor = false
			return
		seen_parts[part] = true
	CharacterManager.ultimate_x_armor = true

func get_collected_armor_pieces() -> Array:
	var armor_pieces: = []
	for collectible in GameManager.collectibles:
		if is_armor(collectible) and not is_in_exceptions(collectible):
			armor_pieces.append(collectible)
	return armor_pieces

func filter_parts(all_armor: Array) -> Array:
	var currently_equipped_pieces: = []
	var body_parts_with_armor = []
	var i: = all_armor.size() - 1
	
	while i >= 0:
		var body_part = get_body_part_name(all_armor[i])
		if not body_part in body_parts_with_armor:
			currently_equipped_pieces.append(all_armor[i])
			body_parts_with_armor.append(body_part)
		i -= 1
	
	if currently_equipped_pieces.size() < 4:
		var n = ["head", "arms", "body", "legs"]
		for exception in n:
			if not exception in body_parts_with_armor:
				GameManager.add_equip_exception(exception)
				
	return currently_equipped_pieces

func emit_unlocked_set_signals() -> void :
	var hermes_pieces: = 0
	var icarus_pieces: = 0
	var ultimate_pieces: = 0
	for item in GameManager.collectibles:
		if "hermes" in item: hermes_pieces += 1
		elif "icarus" in item: icarus_pieces += 1
		elif "ultima" in item: ultimate_pieces += 1
	if hermes_pieces == 4: emit_signal("unlocked_hermes")
	if icarus_pieces == 4: emit_signal("unlocked_icarus")
	if ultimate_pieces == 4: emit_signal("unlocked_ultimate")

func emit_current_set_signals() -> void :
	var parts = 0
	for piece in current_armor:
		if "hermes" in piece: parts += 1
		elif "icarus" in piece: parts -= 1
		elif "ultima" in piece: parts += 10
	if parts == 4: Event.emit_signal("full_hermes")
	elif parts == - 4: Event.emit_signal("full_icarus")
	elif parts == 40: Event.emit_signal("full_ultimate")
	else: Event.emit_signal("mixed_set")
	

func equip(part: X8TextureButton) -> void :
	for option in part_options:
		if option != part:
			option.dim()
	update_current_armor()
	visual_armor_unequip(get_body_part_name(part.name))
	visual_armor_equip(part.name)
	visual_equip_neck_parts(part)

func visual_equip_neck_parts(part: X8TextureButton) -> void :
	if is_armor(part.name) and get_body_part_name(part.name) == "body":
		visual_armor_equip(part.name + "_neck", false)

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

func align(part_name: String = "none") -> void :
	if "icarus" in part_name:
		alignment = BoxContainer.ALIGN_CENTER
	elif "hermes" in part_name:
		alignment = BoxContainer.ALIGN_CENTER
	elif "ultima" in part_name:
		alignment = BoxContainer.ALIGN_CENTER
	else:
		alignment = BoxContainer.ALIGN_CENTER

func is_armor(armor_name: String) -> bool:
	return "icarus" in armor_name or "hermes" in armor_name or "ultima" in armor_name

func get_body_part_name(collectible_name: String) -> String:
	if collectible_name.length() <= 4:
		return collectible_name
	return collectible_name.substr(7)

func is_in_exceptions(armor_name: String) -> bool:
	if get_body_part_name(armor_name) in GameManager.equip_exceptions:
		return true
	return false
