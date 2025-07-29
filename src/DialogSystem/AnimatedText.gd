extends Label
class_name DialogBox

const portrait_position_1: int = 15
const portrait_position_2: int = 175

export  var debug_messages: bool = true
export  var debug_force_start: bool = false
export  var dialog_tree: Resource
export  var emit_capsule_signal: bool = true
export  var resume_character_inputs: bool = true

onready var parent = get_parent()
onready var letter_sound: AudioStreamPlayer = $audioStreamPlayer
onready var portrait_1: AnimatedSprite = $Portrait1
onready var portrait_2: AnimatedSprite = $Portrait2
onready var bg: Sprite = $BG
onready var next_dialogue: AnimatedSprite = $next_dialogue
onready var portrait_side: Label = $portrait_side
onready var axl_material: Material = preload("res://Axl_mod/Player/Axl_Material_Shader.tres")
onready var zero_material: Material = preload("res://Zero_mod/Sprites/Zero_Material_Shader.tres")

var dialog_step: int = 0
var total_steps: int = 0
var timer: float = 0.0001
var time_between_letters: float = 0.055
var bg_scale: Vector2
var bg_grow_speed: int = 2
var text_to_display: String = ""
var state: String = "stopped"
var character: String = "Default"

signal dialog_concluded


func set_axl_palette() -> void :
	portrait_1.material = axl_material
	CharacterManager.set_axl_colors(portrait_1)
	if parent:
		if parent.name == "FinalCutscene":
			reset_palettes()
	
func set_zero_palette() -> void :
	portrait_1.material = zero_material
	CharacterManager.set_zero_colors(portrait_1)
	if parent:
		if parent.name == "FinalCutscene":
			reset_palettes()
	
func reset_palettes() -> void :
	portrait_1.material = null

func _ready() -> void :
	bg_scale = bg.scale
	bg.scale = Vector2.ZERO
	hide_text()
	hide_portraits()
	hide_next_arrow()
	GameManager.dialog_box = self
	if debug_force_start:
		startup()

func startup(alt_dialog_tree = null) -> void :
	bg.scale = Vector2.ZERO
	hide_text()
	hide_portraits()
	hide_next_arrow()
	if alt_dialog_tree:
		dialog_tree = alt_dialog_tree
	dialog_step = 0
	load_dialog_tree()
	state = "growing"
	Event.emit_signal("dialog_started")

func handle_extra_lines() -> void :
	var complete_text = text_to_display.split(" ", false)
	text = ""
	portrait_side.text = ""
	
	for word in complete_text:
		if get_line_count() <= 3:
			text += word + " "
		else:
			portrait_side.text += word + " "
			
	if get_line_count() > 3:
		take_last_word_from_text_and_add_to_side_text()

func take_last_word_from_text_and_add_to_side_text() -> void :
	var top_text = text.split(" ")
	var last_word = top_text[top_text.size() - 2]
	portrait_side.text = portrait_side.text.insert(0, last_word + " ")
	var correct_txt = text
	correct_txt.erase(text.length() - last_word.length() - 1, last_word.length())
	text = correct_txt

func load_dialog_tree() -> void :
	total_steps = dialog_tree.dialog.size()
	state = "growing"
	load_step()

func load_step() -> void :
	if total_steps <= dialog_step:
		hide_text()
		hide_portraits()
		hide_next_arrow()
		state = "shrinking"
		return
	var step = get_current_step()
	if step is DialogueProfile:
		setup_character(step)
		increase_step()
		load_step()
	elif step is String:
		text_to_display = tr(step)
		handle_extra_lines()
		hide_text()
		state = "entering_text"

func increase_step() -> void :
	dialog_step = dialog_step + 1

func setup_character(step) -> void :
	portrait_1.frames = step.portrait_animations
	material.set_shader_param("palette", step.text_palette)
	letter_sound.pitch_scale = step.audio_pitch
	if step.name == "MegaMan X":
		portrait_1.position.x = portrait_position_1
		portrait_side.margin_left = 36
		portrait_side.margin_right = 176
	elif step.name == "Zero":
		portrait_1.position.x = portrait_position_1
		portrait_side.margin_left = 36
		portrait_side.margin_right = 176
		set_zero_palette()
	elif step.name == "Axl":
		portrait_1.position.x = portrait_position_1
		portrait_side.margin_left = 36
		portrait_side.margin_right = 176
		set_axl_palette()
	else:
		reset_palettes()
		portrait_1.position.x = portrait_position_2
		portrait_side.margin_left = 0
		portrait_side.margin_right = 141
	character = step.name
	

func get_current_step():
	return dialog_tree.dialog[dialog_step]

func _physics_process(delta: float) -> void :
	if state != "stopped":
		if player_forced_end_of_dialog():
			force_end()
			
	if state == "growing":
		grow(delta)
	elif state == "entering_text":
		enter_text(delta)
	elif state == "waiting_input":
		wait_input()
	elif state == "shrinking":
		shrink(delta)

func player_forced_end_of_dialog() -> bool:
	if Configurations.exists("SkipDialog"):
		if Configurations.get("SkipDialog"):
			return Input.is_action_pressed("pause")
	return false

func grow(delta: float) -> void :
	if bg.scale.x < bg_scale.x:
		bg.scale.x += delta * bg_grow_speed
	if bg.scale.y < bg_scale.y:
		bg.scale.y += delta * bg_grow_speed
	if bg.scale.y > bg_scale.y:
		bg.scale.y = bg_scale.y
	if bg.scale.x >= bg_scale.x:
		bg.scale = bg_scale
		state = "entering_text"
		portrait_1.visible = true

func enter_text(delta: float) -> void :
	timer += delta
	Event.emit_signal("character_talking", character)
	if timer > time_between_letters:
		portrait_1.animation = "talk"
		timer = 0
		if not has_finished_displaying_chars():
			add_visible_char()
		elif not has_finished_displaying_side_chars():
			add_visible_side_char()

	if not has_side_text() and has_finished_displaying_chars() or has_side_text() and has_finished_displaying_side_chars() or is_action_pressed():
		state = "waiting_input"
		Event.emit_signal("stopped_talking", character)

const invalid_characters: = [" ", "\'", ",", ".", "?", "!", "-"]

func play_sound_based_on_displayed_letter(letter: String) -> void :
	if not letter in invalid_characters:
		letter_sound.play()

func add_visible_char() -> void :
	visible_characters = visible_characters + 1
	play_sound_based_on_displayed_letter(text[visible_characters])

func add_visible_side_char() -> void :
	portrait_side.visible_characters = portrait_side.visible_characters + 1
	play_sound_based_on_displayed_letter(portrait_side.text[portrait_side.visible_characters])
	
func has_side_text() -> bool:
	return total_side_chars() != 0

func has_finished_displaying_side_chars() -> bool:
	return side_visible_chars() >= total_side_chars()

func has_finished_displaying_chars() -> bool:
	return visible_characters >= get_total_character_count()

func total_side_chars() -> int:
	return portrait_side.get_total_character_count()

func side_visible_chars() -> int:
	return portrait_side.visible_characters

func wait_input() -> void :
	Event.emit_signal("character_talking", "none")
	visible_characters = get_total_character_count()
	portrait_side.visible_characters = total_side_chars()
	portrait_1.animation = "idle"
	next_dialogue.visible = true
	if is_action_pressed():
		hide_next_arrow()
		increase_step()
		load_step()

func shrink(delta: float) -> void :
	if bg.scale.x > 0:
		bg.scale.x -= delta * bg_grow_speed
	if bg.scale.y > 0:
		bg.scale.y -= delta * bg_grow_speed
	if bg.scale.y < 0:
		bg.scale.y = 0
	if bg.scale.y <= 0.01:
		end_dialog()

func force_end() -> void :
	hide_next_arrow()
	hide_portraits()
	hide_text()
	Event.emit_signal("character_talking", "none")
	state = "shrinking"

func end_dialog() -> void :
	state = "stopped"
	hide_next_arrow()
	hide_portraits()
	hide_text()
	bg.scale = Vector2.ZERO
	emit_signal("dialog_concluded")
	Event.emit_signal("dialog_concluded")
	if resume_character_inputs:
		GameManager.resume_character_inputs()
	GameManager.save_seen_dialogue(dialog_tree)
	if emit_capsule_signal:
		Event.emit_signal("capsule_dialogue_end")

func is_action_pressed() -> bool:
	if Input.is_action_just_pressed("fire") or Input.is_action_just_pressed("ui_accept"):
		
		return true
	return false

func debug_print(message: String) -> void :
	if debug_messages:
		print("DialogSystem: " + message)

func hide_text() -> void :
	visible_characters = 0
	portrait_side.visible_characters = 0

func hide_next_arrow() -> void :
	next_dialogue.visible = false

func hide_portraits() -> void :
	portrait_1.visible = false
	portrait_2.visible = false

func _get_real_line_count() -> int:
	var line_count = get_line_count()
	var lines_to_add = 0
	return line_count + lines_to_add
