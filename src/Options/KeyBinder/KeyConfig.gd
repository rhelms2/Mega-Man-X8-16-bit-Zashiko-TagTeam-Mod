extends CanvasLayer
class_name X8Menu

export  var menu_path: NodePath
export  var initial_focus: NodePath
export  var exit_action: String = "none"
export  var exit_action_2: String = "none"
export  var exit_action_3: String = "none"
export  var start_emit_event: String = "none"

onready var menu: Control = get_node(menu_path)
onready var focus: Control = get_node(initial_focus)
onready var fader: ColorRect = $Fader
onready var choice: AudioStreamPlayer = $choice
onready var equip: AudioStreamPlayer = $equip
onready var pick: AudioStreamPlayer = $pick
onready var cancel: AudioStreamPlayer = $cancel
onready var player_count: int = CharacterManager.player_count

var active: bool = false
var locked: bool = true

signal initialize
signal start
signal end
signal lock_buttons
signal unlock_buttons

func _input(event: InputEvent) -> void :
	if active and not locked:
		if exit_action != "none" and event.is_action_pressed(exit_action):
			end()
		if exit_action_2 != "none" and event.is_action_pressed(exit_action_2):
			end()
		if exit_action_3 != "none" and event.is_action_pressed(exit_action_3):
			end()

func _ready() -> void :
	set_visible_elements()
	if get_parent().name == "root":
		start()
	else:
		menu.visible = false
		visible = true

func set_visible_elements() -> void :
	if get_parent().has_node("ArmorSetup"):
		player_count = CharacterManager.player_count
		CharacterManager.assign_name_to_player_counter(player_count)
		hide_special_holders()
		show_special_holders()
		update_character_menu()
		$Menu.get_node("CharacterName").text = CharacterManager.player_character
		if CharacterManager.player_character == "Zero" and CharacterManager.betazero_activated:
			$Menu.get_node("CharacterName").text = "Zero (BETA)"

func switch_to_zero() -> void :
	equip.play()
	player_count = 3
	CharacterManager.player_count = player_count
	set_visible_elements()

func change_prev_character() -> void :
	change_character( - 1)

func change_next_character() -> void :
	change_character(1)

func change_character(direction: int) -> void :
	player_count += direction
	if player_count > CharacterManager.max_player_count:
		player_count = CharacterManager.min_player_count
	elif player_count < CharacterManager.min_player_count:
		player_count = CharacterManager.max_player_count
	CharacterManager.player_count = player_count
	pick.play()
	set_visible_elements()

func hide_all_characters(texture_rect: TextureRect) -> void :
	texture_rect.get_node("X").hide()
	texture_rect.get_node("Axl").hide()
	texture_rect.get_node("Zero").hide()

func show_special_holders() -> void :
	if has_hermes_armor():
		$Menu.get_node("special_holder").show()
	if has_icarus_armor():
		$Menu.get_node("special_holder2").show()
	if has_ultimate_armor():
		$Menu.get_node("special_holder3").show()

func hide_special_holders() -> void :
	$Menu.get_node("special_holder").hide()
	$Menu.get_node("special_holder2").hide()
	$Menu.get_node("special_holder3").hide()

func update_character_menu() -> void :
	var _textureRect: TextureRect = $Menu.get_node("textureRect")
	hide_all_characters(_textureRect)
	match CharacterManager.player_character:
		"Player":
			hide_special_holders()
		"X":
			_textureRect.get_node("X").show()
		"Axl":
			_textureRect.get_node("Axl").show()
			hide_special_holders()
		"Zero":
			_textureRect.get_node("Zero").show()
			hide_special_holders()
			if CharacterManager.betazero_unlocked:
				$Menu / textureRect / Zero / betazero_holder.show()
			if CharacterManager.custom_zero_unlocked:
				$Menu/textureRect/Zero/customzero_holder.show()

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

func start() -> void :
	GameManager.set_stretch_mode(SceneTree.STRETCH_MODE_2D)
	set_visible_elements()
	emit_signal("initialize")
	active = true
	emit_signal("lock_buttons")
	if start_emit_event != "none":
		Event.emit_signal(start_emit_event)
	if has_node("Menu/scrollContainer/OptionHolder/ShowDebug"):
		$"Menu/scrollContainer/OptionHolder/ShowDebug".visible = GameManager.debug_enabled
	fader.visible = true
	fader.FadeIn()
	yield(fader, "finished")
	unlock_buttons()
	emit_signal("start")
	call_deferred("give_focus")

func give_focus() -> void :
	focus.silent = true
	focus.grab_focus()

func end() -> void :
	play_cancel_sound()
	lock_buttons()
	fader.FadeOut()
	yield(fader, "finished")
	GameManager.reset_stretch_mode()
	emit_signal("end")
	active = false
	IGT.save_time()
	Savefile.save(Savefile.save_slot)
	CharacterManager._save()

func play_choice_sound() -> void :
	choice.play()
	
func play_pick_sound() -> void :
	pick.play()
	
func play_equip_sound() -> void :
	equip.play()
	
func play_cancel_sound() -> void :
	cancel.play()

func button_call(method, param = null) -> void :
	if param:
		call_deferred(method, param)
	else:
		call(method)

func lock_buttons() -> void :
	emit_signal("lock_buttons")
	locked = true

func unlock_buttons() -> void :
	emit_signal("unlock_buttons")
	locked = false
