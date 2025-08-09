extends CanvasLayer

const music_0_intro: AudioStream = preload("res://src/Sounds/OST - Stage Select 1 - Intro.ogg")
const music_0_loop: AudioStream = preload("res://src/Sounds/OST - Stage Select 1 - Loop.ogg")
const music_1_intro: AudioStream = preload("res://src/Sounds/OST - StageSelect3 - Intro.ogg")
const music_1_loop: AudioStream = preload("res://src/Sounds/OST - StageSelect3 - Loop.ogg")
const music_1_16bit_intro: AudioStream = preload("res://Remix/Songs/Stage Select 1 - Intro.ogg")
const music_1_16bit_loop: AudioStream = preload("res://Remix/Songs/Stage Select 1 - Loop.ogg")
const music_2_16bit_intro: AudioStream = preload("res://Remix/Songs/Stage Select 2 - Intro.ogg")
const music_2_16bit_loop: AudioStream = preload("res://Remix/Songs/Stage Select 2 - Loop.ogg")
const music_3_16bit_intro: AudioStream = preload("res://Remix/Songs/Stage Select 3 - Intro.ogg")
const music_3_16bit_loop: AudioStream = preload("res://Remix/Songs/Stage Select 3 - Loop.ogg")

export  var initial_focus: NodePath

onready var choice: AudioStreamPlayer = $choice
onready var bg: Sprite = $"../bg"
onready var frame: Sprite = $"../frame"
onready var fader: ColorRect = $Fader
onready var pick: AudioStreamPlayer = $pick
onready var music: AudioStreamPlayer = $"../music"
onready var jacob_elevator: TextureButton = $Menu / JacobElevator
onready var gateway: TextureButton = $Menu / Gateway
onready var sigma_palace: TextureButton = $Menu / SigmaPalace
onready var last_stages: Array = [jacob_elevator, gateway, sigma_palace]
onready var game_mode_label: Label = $game_mode

signal lock_buttons
signal unlock_buttons
signal picked_stage


func _ready() -> void :
	GameManager.force_unpause()
	lock_buttons()
	call_deferred("show_last_stages_and_play_music")
	fade_in()
	Tools.timer(0.75, "unlock_and_give_initial_focus", self)
	Tools.timer(0.1, "set_game_mode_label", self)

func set_game_mode_label() -> void :
	if CharacterManager.game_mode == - 1:
		game_mode_label.modulate = Color("#329632")
		game_mode_label.modulate = Color("#8cff8c")
	elif CharacterManager.game_mode == 0:
		game_mode_label.modulate = Color("#68caff")
		game_mode_label.modulate = Color("#fbffaf")
	elif CharacterManager.game_mode == 1:
		game_mode_label.modulate = Color("#960000")
		game_mode_label.modulate = Color("#ff4b4b")
	elif CharacterManager.game_mode == 2:
		game_mode_label.modulate = Color("#771313")
		game_mode_label.modulate = Color("#ff7200")
	elif CharacterManager.game_mode == 3:
		game_mode_label.modulate = Color("#832b7f")
		game_mode_label.modulate = Color("#e090f2")
	game_mode_label.text = tr(CharacterManager.GAME_MODE)

func unlock_and_give_initial_focus() -> void :
	unlock_buttons()
	if not give_priority_to_last_stage():
		get_node(initial_focus).silent = true
		get_node(initial_focus).grab_focus()

func show_last_stages_and_play_music() -> void :
	var level: = 0
	for stage in last_stages:
		stage.visible = stage.stage_info.can_be_played()
		if stage.visible:
			level = stage.frame
	frame.switch(level)
	play_stage_select_song(level)

func play_stage_select_song(intensity: int = 0) -> void :
	if Configurations.exists("SongRemix"):
		if Configurations.get("SongRemix"):
			if intensity == 0:
				music.play_with_intro(music_1_16bit_intro, music_1_16bit_loop)
			elif intensity == 1 or intensity == 2:
				music.play_with_intro(music_2_16bit_intro, music_2_16bit_loop)
			elif intensity > 2:
				music.play_with_intro(music_3_16bit_intro, music_3_16bit_loop)
			if music.music != null:
				music.music.loop = true
		else:
			if intensity == 0:
				music.play_with_intro(music_0_intro, music_0_loop)
			elif intensity == 1 or intensity == 2:
				music.play_with_intro()
			elif intensity > 2:
				music.play_with_intro(music_1_intro, music_1_loop)

func play_choice_sound() -> void :
	choice.play()

func lock_buttons() -> void :
	emit_signal("lock_buttons")

func unlock_buttons() -> void :
	emit_signal("unlock_buttons")

func picked_stage(stage: StageInfo) -> void :
	emit_signal("picked_stage")
	lock_buttons()
	flash()
	pick.play()
	music.fade_out(2.0)
	Tools.timer(0.48, "fade_out", self)
	Tools.timer_p(2.5, "on_fadeout_finished", self, stage)

func on_fadeout_finished(stage: StageInfo) -> void :
	if stage.should_play_stage_intro():
		GameManager.go_to_stage_intro(stage)
	else:
		GameManager.start_level(stage.get_load_name())

func fade_out() -> void :
	fader.color = Color(0, 0, 0, 0)
	fader.visible = true
	Tools.tween(fader, "color", Color.black, 0.5)

func fade_in() -> void :
	fader.color = Color.black
	fader.visible = true
	Tools.tween(fader, "color", Color(0, 0, 0, 0), 0.75)

func flash() -> void :
	white_bg()
	var interval: = 0.016
	var i: = 0
	var n: = 1
	while i < 19:
		Tools.timer(interval + interval * i, get_flash_bg(n), self)
		i += 1
		n *= - 1

func get_flash_bg(n: int) -> String:
	if n > 0:
		return "normal_bg"
	return "white_bg"

func white_bg() -> void :
	bg.modulate = Color(4, 4, 4, 1)
	frame.modulate = Color(3, 3, 3, 1)

func normal_bg() -> void :
	bg.modulate = Color(1, 1, 1, 1)
	frame.modulate = Color(1, 1, 1, 1)

func give_priority_to_last_stage() -> bool:
	var i = 0
	var priority_stage: TextureButton
	for stage_button in last_stages:
		if stage_button.visible:
			if stage_button.intensity > i:
				i = stage_button.intensity
				priority_stage = stage_button
	if i > 0:
		priority_stage.silent = true
		priority_stage.grab_focus()
	return i > 0
