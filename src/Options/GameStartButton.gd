extends X8TextureButton

export  var pick_sound: NodePath
onready var label: Label = $text

var all_modes: PoolIntArray = [ - 1, 0, 1, 2, 3]
var modes: PoolIntArray = []
var labels: Dictionary = {
	- 1: "GAME_START_ROOKIE", 
		0: "GAME_START", 
		1: "GAME_START_HARD", 
		2: "GAME_START_INSANITY", 
		3: "GAME_START_NINJA"
}

func _ready() -> void :
	build_mode_list()
	update_game_mode(CharacterManager.game_mode)

func _process(_delta: float) -> void :
	if not has_focus() or CharacterManager.game_mode_set:
		return
	
	var current_index: int = modes.find(CharacterManager.game_mode)
	if Input.is_action_just_pressed("move_left") and current_index > 0:
		update_game_mode(modes[current_index - 1])
		_on_focus_entered()
	elif Input.is_action_just_pressed("move_right") and current_index < modes.size() - 1:
		update_game_mode(modes[current_index + 1])
		_on_focus_entered()

func build_mode_list() -> void :
	modes = [ - 1, 0, 1]
	if CharacterManager.beaten_hard:
		modes.append(2)
	if CharacterManager.beaten_insanity:
		modes.append(3)

func update_game_mode(mode: int) -> void :
	CharacterManager.game_mode = mode
	if CharacterManager.game_mode == - 1:
		idle_color = Color("#329632")
		focus_color = Color("#8cff8c")
	elif CharacterManager.game_mode == 0:
		idle_color = Color("#68caff")
		focus_color = Color("#fbffaf")
	elif CharacterManager.game_mode == 1:
		idle_color = Color("#960000")
		focus_color = Color("#ff4b4b")
	elif CharacterManager.game_mode == 2:
		idle_color = Color("#771313")
		focus_color = Color("#ff7200")
	elif CharacterManager.game_mode == 3:
		idle_color = Color("#832b7f")
		focus_color = Color("#e090f2")
		
	label.text = tr(labels.get(CharacterManager.game_mode, "GAME_START"))
	CharacterManager.update_game_mode()
	_on_focus_exited()

func on_press() -> void :
	CharacterManager.game_mode_set = true
	get_node(pick_sound).play()
	Event.emit_signal("fadeout_startmenu")
	strong_flash()
	menu.lock_buttons()
	menu.fader.SoftFadeOut()
	yield(menu.fader, "finished")
	
	go_to_next_scene()

func go_to_next_scene() -> void :
	if already_finished_noahs_park():
		GameManager.call_deferred("go_to_stage_select")
	else:
		get_tree().change_scene("res://System/Screens/CharacterSelection/Character_Selection.tscn")

func already_finished_noahs_park() -> bool:
	return "finished_intro" in GameManager.collectibles
