extends CanvasLayer

export  var song_intro: AudioStream
export  var song_loop: AudioStream
export  var menu_path: NodePath
export  var initial_focus: NodePath
export  var exit_action: String = "none"

onready var musicplayer: AudioStreamPlayer = $Music_Player
onready var menu: Control = get_node(menu_path)
onready var focus: Control = get_node(initial_focus)
onready var fader: ColorRect = $Fader
onready var choice: AudioStreamPlayer = $choice
onready var equip: AudioStreamPlayer = $equip
onready var pick: AudioStreamPlayer = $pick
onready var cancel: AudioStreamPlayer = $cancel

var active: bool = false
var locked: bool = true

signal initialize
signal start
signal end
signal lock_buttons
signal unlock_buttons


func _input(event: InputEvent) -> void :
	if active:
		if exit_action != "none" and event.is_action_pressed(exit_action):
			end()

func end() -> void :
	cancel.play()
	lock_buttons()
	fader.FadeOut()
	yield(fader, "finished")
	GameManager.go_to_intro()
	emit_signal("end")
	active = false

func play_music() -> void :
	song_loop.loop = true
	musicplayer.play_song(song_loop, song_intro)

func _ready() -> void :
	if get_parent().name == "root":
		start()
	else:
		menu.visible = false
		visible = true
	call_deferred("play_music")

func start() -> void :
	emit_signal("start")
	emit_signal("initialize")
	emit_signal("lock_buttons")
	active = true
	fader.visible = true
	fader.FadeIn()
	unlock_buttons()
	call_deferred("give_focus")
	CharacterManager._save()

func give_focus() -> void :
	focus.silent = true
	focus.grab_focus()
	
func play_choice_sound() -> void :
	choice.play()

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
