extends HBoxContainer

onready var menu_frame: TextureRect = $"../../../Menu_Frame"
onready var left_panel: Control = menu_frame.get_node("Left")
onready var right_panel: Control = menu_frame.get_node("Right")
onready var char_face_frame: TextureRect = left_panel.get_node("char_face_frame")
onready var left_desc: RichTextLabel = left_panel.get_node("Description_Left")
onready var right_name: Label = right_panel.get_node("Name_Right")
onready var right_desc: RichTextLabel = right_panel.get_node("Description_Right")
onready var gamestart_button: = $"../../../Menu_Frame/GameStart"

onready var wireframes: Control = $"../../Wireframes"
onready var wireframe_x: TextureRect = wireframes.get_node("wireframe_X")
onready var wireframe_zero: TextureRect = wireframes.get_node("wireframe_Zero")
onready var wireframe_axl: TextureRect = wireframes.get_node("wireframe_Axl")

onready var face_x: TextureRect = char_face_frame.get_node("face_X")
onready var face_zero: TextureRect = char_face_frame.get_node("face_Zero")
onready var face_axl: TextureRect = char_face_frame.get_node("face_Axl")

onready var sprite_x: TextureRect = get_node("X")
onready var sprite_zero: TextureRect = get_node("Zero")
onready var sprite_axl: TextureRect = get_node("Axl")

onready var game_start: X8TextureButton = menu_frame.get_node("GameStart")
onready var game_start_label: Label = game_start.get_node("text")

onready var equip: AudioStreamPlayer = $"../../../../equip"
onready var choice: AudioStreamPlayer = $"../../../../choice"
onready var pick: AudioStreamPlayer = $"../../../../pick"

onready var x_base: Texture = preload("res://System/Screens/CharacterSelection/X.png")
onready var x_icarus: Texture = preload("res://System/Screens/CharacterSelection/X_Icarus.png")
onready var x_hermes: Texture = preload("res://System/Screens/CharacterSelection/X_Hermes.png")
onready var x_ultimate: Texture = preload("res://System/Screens/CharacterSelection/X_Ultimate.png")

var x_armor: int = 0
var characters: Array = []
var animating: bool = false
var direction: String = ""



var x_left_desc: String = "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_1") + "[/color]\n" + tr("X_LEFT_DESC_1") + "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_2") + "[/color]\n" + tr("X_LEFT_DESC_2") +  "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_3") + "[/color]\n" + tr("X_LEFT_DESC_3") + "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_4") + "[/color]\n" + tr("X_LEFT_DESC_4")
var x_right_desc: String = "\n\n" + tr("X_RIGHT_DESC")

var zero_left_desc: String = "\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_1") + "[/color]\n" + tr("ZERO_LEFT_DESC_1") + "\n\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_2") + "[/color]\n" + tr("ZERO_LEFT_DESC_2") +  "\n\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_3") + "[/color]\n" + tr("ZERO_LEFT_DESC_3") + "\n\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_4") + "[/color]\n" + tr("ZERO_LEFT_DESC_4")
var zero_right_desc: String = "\n\n" + tr("ZERO_RIGHT_DESC")

var axl_left_desc: String = "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_1") + "[/color]\n" + tr("AXL_LEFT_DESC_1") + "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_2") + "[/color]\n" + tr("AXL_LEFT_DESC_2") +  "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_3") + "[/color]\n" + tr("AXL_LEFT_DESC_3") + "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_4") + "[/color]\n" + tr("AXL_LEFT_DESC_4")
var axl_right_desc: String = "\n\n" + tr("AXL_RIGHT_DESC")


signal switch_character(direction)

func update_text():
	x_left_desc = "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_1") + "[/color]\n" + tr("X_LEFT_DESC_1") + "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_2") + "[/color]\n" + tr("X_LEFT_DESC_2") +  "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_3") + "[/color]\n" + tr("X_LEFT_DESC_3") + "\n\n[color=#47a1fc]" + tr("X_LEFT_TITLE_4") + "[/color]\n" + tr("X_LEFT_DESC_4")
	x_right_desc = "\n\n" + tr("X_RIGHT_DESC")

	zero_left_desc = "\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_1") + "[/color]\n" + tr("ZERO_LEFT_DESC_1") + "\n\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_2") + "[/color]\n" + tr("ZERO_LEFT_DESC_2") +  "\n\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_3") + "[/color]\n" + tr("ZERO_LEFT_DESC_3") + "\n\n[color=#47a1fc]" + tr("ZERO_LEFT_TITLE_4") + "[/color]\n" + tr("ZERO_LEFT_DESC_4")
	zero_right_desc = "\n\n" + tr("ZERO_RIGHT_DESC")

	axl_left_desc = "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_1") + "[/color]\n" + tr("AXL_LEFT_DESC_1") + "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_2") + "[/color]\n" + tr("AXL_LEFT_DESC_2") +  "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_3") + "[/color]\n" + tr("AXL_LEFT_DESC_3") + "\n\n[color=#47a1fc]" + tr("AXL_LEFT_TITLE_4") + "[/color]\n" + tr("AXL_LEFT_DESC_4")
	axl_right_desc = "\n\n" + tr("AXL_RIGHT_DESC")

func _ready() -> void :
	Event.connect("translation_updated",self,"update_text")
	connect("switch_character", self, "switch_characters")
	characters = get_children()
	for child in characters:
		child.rect_min_size = Vector2(40, 48)
	set_menu_visibility()

	CharacterManager.black_zero_armor = false
	CharacterManager.set_zeroX8_colors(sprite_zero)

	CharacterManager.white_axl_armor = false
	CharacterManager.set_axl_colors(sprite_axl)

func hide_all_wireframes() -> void :
	wireframe_x.hide()
	wireframe_zero.hide()
	wireframe_axl.hide()
	face_x.hide()
	face_zero.hide()
	face_axl.hide()

func set_menu_visibility() -> void :
	hide_all_wireframes()
	if "X" in characters[1].name:
		game_start.char_name = "X"
		game_start_label.text = tr("GAME_START_X")
		wireframe_x.show()
		face_x.show()
		left_desc.bbcode_text = x_left_desc
		right_name.text = "X"
		right_desc.bbcode_text = x_right_desc
		
	if "Zero" in characters[1].name:
		game_start.char_name = "Zero"
		game_start_label.text = tr("GAME_START_ZERO")
		wireframe_zero.show()
		face_zero.show()
		left_desc.bbcode_text = zero_left_desc
		right_name.text = "Zero"
		right_desc.bbcode_text = zero_right_desc
		
	if "Axl" in characters[1].name:
		game_start.char_name = "Axl"
		game_start_label.text = tr("GAME_START_AXL")
		wireframe_axl.show()
		face_axl.show()
		left_desc.bbcode_text = axl_left_desc
		right_name.text = "Axl"
		right_desc.bbcode_text = axl_right_desc

func _input(event: InputEvent) -> void :
	if Input.is_action_just_pressed("move_right"):
		emit_signal("switch_character", "right")
	elif Input.is_action_just_pressed("move_left"):
		emit_signal("switch_character", "left")
		
	if Input.is_action_just_pressed("move_up"):
		switch_armor( - 1)
	elif Input.is_action_just_pressed("move_down"):
		switch_armor(1)
		
	if Input.is_action_just_pressed("ui_accept"):
		gamestart_button.on_press()

func has_icarus_armor() -> bool:
	var part: int = 0
	for piece in GameManager.collectibles:
		if "icarus" in piece:
			part += 1
	return part == 4

func has_hermes_armor() -> bool:
	var part: int = 0
	for piece in GameManager.collectibles:
		if "hermes" in piece:
			part += 1
	return part == 4

func has_ultimate_armor() -> bool:
	var part: int = 0
	for piece in GameManager.collectibles:
		if "ultima" in piece:
			part += 1
	return part == 4

func get_available_armors() -> PoolIntArray:
	var list: PoolIntArray = [0]
	if has_icarus_armor():
		list.append(1)
	if has_hermes_armor():
		list.append(2)
	if has_ultimate_armor():
		list.append(3)
	return list

func switch_armor(dir) -> void :
	if right_name.text == "Zero":
		if not "black_zero_armor" in GameManager.collectibles:
			return
		if CharacterManager.black_zero_armor:
			CharacterManager.black_zero_armor = false
		else:
			CharacterManager.black_zero_armor = true
		CharacterManager.set_zeroX8_colors(sprite_zero)
		
	if right_name.text == "Axl":
		if not "white_axl_armor" in GameManager.collectibles:
			return
		if CharacterManager.white_axl_armor:
			CharacterManager.white_axl_armor = false
		else:
			CharacterManager.white_axl_armor = true
		CharacterManager.set_axl_colors(sprite_axl)
		
	if right_name.text == "X":
		var available_armors: PoolIntArray = get_available_armors()
		if available_armors.size() <= 1:
			return
			
		var current_index: int = available_armors.find(x_armor)
		if current_index == - 1:
			current_index = 0
			
		var new_index: int = (current_index + dir) %available_armors.size()
		if new_index < 0:
			new_index += available_armors.size()
			
		x_armor = available_armors[new_index]
		if x_armor == 0:
			sprite_x.texture = x_base
			GameManager.add_equip_exception("head")
			GameManager.add_equip_exception("body")
			GameManager.add_equip_exception("arms")
			GameManager.add_equip_exception("legs")
			CharacterManager.ultimate_x_armor = false
		elif x_armor == 1:
			sprite_x.texture = x_icarus
			GameManager.reposition_collectible_in_savedata("icarus_head")
			GameManager.reposition_collectible_in_savedata("icarus_body")
			GameManager.reposition_collectible_in_savedata("icarus_arms")
			GameManager.reposition_collectible_in_savedata("icarus_legs")
			CharacterManager.ultimate_x_armor = false
		elif x_armor == 2:
			sprite_x.texture = x_hermes
			GameManager.reposition_collectible_in_savedata("hermes_head")
			GameManager.reposition_collectible_in_savedata("hermes_body")
			GameManager.reposition_collectible_in_savedata("hermes_arms")
			GameManager.reposition_collectible_in_savedata("hermes_legs")
			CharacterManager.ultimate_x_armor = false
		elif x_armor == 3:
			sprite_x.texture = x_ultimate
			GameManager.reposition_collectible_in_savedata("ultima_head")
			GameManager.reposition_collectible_in_savedata("ultima_body")
			GameManager.reposition_collectible_in_savedata("ultima_arms")
			GameManager.reposition_collectible_in_savedata("ultima_legs")
			CharacterManager.ultimate_x_armor = true
			
		if x_armor > 0:
			GameManager.remove_equip_exception("head")
			GameManager.remove_equip_exception("body")
			GameManager.remove_equip_exception("arms")
			GameManager.remove_equip_exception("legs")
			
	choice.play()
	apply_armor_to_all_characters()

func apply_armor_to_all_characters() -> void :
	for _char in characters:
		if "X" in _char.name:
			match x_armor:
				0:
					_char.texture = x_base
				1:
					_char.texture = x_icarus
				2:
					_char.texture = x_hermes
				3:
					_char.texture = x_ultimate

func switch_characters(new_direction: String) -> void :
	if animating:
		return
		
	equip.play()
	animating = true
	direction = new_direction
	var animation_time: float = 0.2
	var copy_character: TextureRect
	
	if direction == "right":
		copy_character = characters[0].duplicate()
		add_child(copy_character)
		move_child(copy_character, characters.size())
		copy_character.rect_position = characters[ - 1].rect_position + Vector2(40, 0)
		characters.append(copy_character)
	else:
		copy_character = characters[ - 1].duplicate()
		add_child(copy_character)
		move_child(copy_character, 0)
		copy_character.rect_position = characters[0].rect_position - Vector2(40, 0)
		characters.insert(0, copy_character)
		
	for i in range(characters.size()):
		var tween: Tween = Tween.new()
		add_child(tween)
		
		var start_position: Vector2 = characters[i].rect_position
		var offset: int = 40
		if direction == "right":
			offset = - 40
			
		var target_position: Vector2 = start_position + Vector2(offset, 0)
		tween.interpolate_property(characters[i], "rect_position", start_position, target_position, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		tween.connect("tween_completed", self, "_on_tween_completed")

func _on_tween_completed(object, key) -> void :
	if animating:
		animating = false
		if characters.size() > 3:
			if direction == "right":
				if characters[0].name == "Duplicate" or characters[0].get_index() == 0:
					remove_child(characters[0])
					characters.pop_front()
			else:
				if characters[ - 1].name == "Duplicate" or characters[ - 1].get_index() == characters.size() - 1:
					remove_child(characters[ - 1])
					characters.pop_back()
		set_menu_visibility()
