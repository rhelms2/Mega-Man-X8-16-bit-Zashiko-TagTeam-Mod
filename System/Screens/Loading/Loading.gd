extends CanvasLayer

export  var SlotButtonScene: PackedScene
export  var menu_path: NodePath
export  var initial_focus: NodePath
export  var exit_action: String = "none"
export  var start_emit_event: String = "none"

onready var menu: Control = get_node(menu_path)
onready var focus: Control = get_node(initial_focus)
onready var fader: ColorRect = $Fader
onready var choice: AudioStreamPlayer = $choice
onready var equip: AudioStreamPlayer = $equip
onready var pick: AudioStreamPlayer = $pick
onready var loaded: AudioStreamPlayer = $load
onready var cancel: AudioStreamPlayer = $cancel
onready var save_button_container: VBoxContainer = $Menu / scrollContainer / OptionHolder

var active: bool = false
var locked: bool = true
var current_slot: int = 0
var max_slots: int = 10
var collectibles: Array = [
	"finished_intro", 
	
	"panda_weapon", 
	"sunflower_weapon", 
	"trilobyte_weapon", 
	"manowar_weapon", 
	"yeti_weapon", 
	"rooster_weapon", 
	"antonion_weapon", 
	"mantis_weapon", 
	
	"life_up_panda", 
	"life_up_sunflower", 
	"life_up_trilobyte", 
	"life_up_manowar", 
	"life_up_yeti", 
	"life_up_rooster", 
	"life_up_antonion", 
	"life_up_mantis", 
	
	"subtank_trilobyte", 
	"subtank_sunflower", 
	"subtank_yeti", 
	"subtank_rooster", 
	
	"hermes_head", 
	"hermes_arms", 
	"hermes_body", 
	"hermes_legs", 
	"icarus_head", 
	"icarus_arms", 
	"icarus_body", 
	"icarus_legs", 
	
	"ultima_head", 
	"ultima_arms", 
	"ultima_body", 
	"ultima_legs", 
	"black_zero_armor", 
	"white_axl_armor", 
	
	"defeated_antonion_vile", 
	"defeated_panda_vile", 
	"vile3_defeated", 
	"vile_palace_defeated", 
	
	"copy_sigma_defeated", 
	"seraph_lumine_defeated", 
	
	"b_fan_zero", 
	"d_glaive_zero", 
	"k_knuckle_zero", 
	"t_breaker_zero", 
]
var max_collectibles = collectibles.size()

signal initialize
signal start
signal end
signal lock_buttons
signal unlock_buttons
signal loaded_savefile(gamemode)

func get_completed_items(_collectible, _variable) -> int:
	var collected: int = 0
	for item in _collectible:
		if item in collectibles:
			collected += 1
	for key in _variable.keys():
		if key in collectibles:
			var val = _variable[key]
			match typeof(val):
				TYPE_BOOL:
					if val:
						collected += 1
				TYPE_STRING:
					if "defeated" in val:
						collected += 1
	return collected

func calculate_completion(_collectible, _variable, total_collectibles: int) -> float:
	var collected: int = get_completed_items(_collectible, _variable)
	if total_collectibles == 0:
		return 0.0
	var percentage: = float(collected) / float(total_collectibles) * 100.0
	return percentage

func unix_to_string(unix_time: int) -> String:
	var date = OS.get_datetime_from_unix_time(unix_time)
	return "%04d.%02d.%02d: %02d:%02d" % [
		date.year, date.month, date.day, 
		date.hour, date.minute
	]

func igt_formatting(accumulated_time: float) -> String:
	var hours = int(accumulated_time) / 3600
	var minutes = (int(accumulated_time) %3600) / 60
	var seconds = int(accumulated_time) %60
	var milliseconds = int(accumulated_time * 100) %100
	var hours_str = str(hours).pad_zeros(2)
	var minutes_str = str(minutes).pad_zeros(2)
	var seconds_str = str(seconds).pad_zeros(2)
	var milliseconds_str = str(milliseconds).pad_zeros(2)
	var time_string = hours_str + ":" + minutes_str + ":" + seconds_str + "." + milliseconds_str
	return time_string

func set_current_slot(slot: int) -> void :
	current_slot = slot

func load_all_slots() -> void :
	for child in save_button_container.get_children():
		child.free()
	for slot_index in range(Savefile.max_slots):
		var btn = SlotButtonScene.instance()
		save_button_container.add_child(btn)
		btn.slot_index = slot_index
		btn.slot_number.text = String(slot_index + 1)
		var data = Savefile.load_slot_metadata(slot_index)
		var meta = {}
		if data.has("meta"):
			meta = data["meta"]
		var collectibles = []
		if data.has("collectibles"):
			collectibles = data.get("collectibles", [])
			btn.get_node("boss_icons").visible = true
			var bosses = [
				"panda", 
				"yeti", 
				"manowar", 
				"rooster", 
				"trilobyte", 
				"mantis", 
				"antonion", 
				"sunflower"
			]
			for boss in bosses:
				var weapon_name = boss + "_weapon"
				if weapon_name in collectibles:
					btn.get_node("boss_icons").get_node(boss).get_node("animatedSprite").frame = 1
					
			var secret_bosses = [
				"zero_seen", 
				"zero_defeated", 
			]
			for boss in secret_bosses:
				if boss in collectibles:
					if boss == "zero_seen":
						btn.get_node("boss_icons").get_node("zero").visible = true
					if boss == "zero_defeated":
						btn.get_node("boss_icons").get_node("zero").get_node("animatedSprite").frame = 1
			var items = [
				"white_axl_armor", 
				"black_zero_armor", 
				"ultima_head", 
				"hermes_head", 
				"hermes_body", 
				"hermes_arms", 
				"hermes_legs", 
				"icarus_head", 
				"icarus_body", 
				"icarus_arms", 
				"icarus_legs", 
				"subtank_trilobyte", 
				"subtank_sunflower", 
				"subtank_yeti", 
				"subtank_rooster", 
				"life_up_panda", 
				"life_up_sunflower", 
				"life_up_trilobyte", 
				"life_up_manowar", 
				"life_up_yeti", 
				"life_up_rooster", 
				"life_up_antonion", 
				"life_up_mantis", 
			]
			var hermes_parts: = 0
			var icarus_parts: = 0
			var subtanks: = 0
			var hearts: = 0
			for item in items:
				if item in collectibles:
					if item == "white_axl_armor":
						btn.get_node("item_icons").get_node("white_axl_armor").visible = true
					if item == "black_zero_armor":
						btn.get_node("item_icons").get_node("black_zero_armor").visible = true
					if item == "ultima_head":
						btn.get_node("item_icons").get_node("ultima_head").visible = true
					if "hermes" in item:
						btn.get_node("item_icons").get_node("hermes").visible = true
						hermes_parts += 1
					if "icarus" in item:
						btn.get_node("item_icons").get_node("icarus").visible = true
						icarus_parts += 1
					if "subtank" in item:
						btn.get_node("item_icons").get_node("subtanks").visible = true
						subtanks += 1
					if "life_up" in item:
						btn.get_node("item_icons").get_node("hearts").visible = true
						hearts += 1
			btn.get_node("item_icons").get_node("hermes").get_node("Sprite").get_node("number").text = str(hermes_parts)
			btn.get_node("item_icons").get_node("icarus").get_node("Sprite").get_node("number").text = str(icarus_parts)
			btn.get_node("item_icons").get_node("subtanks").get_node("Sprite").get_node("number").text = str(subtanks)
			btn.get_node("item_icons").get_node("hearts").get_node("Sprite").get_node("number").text = str(hearts)
			
		var variables = {}
		if data.has("variables") and typeof(data["variables"]) == TYPE_DICTIONARY:
			variables = data["variables"]
			var end_bosses = [
				"vile3_defeated", 
				"copy_sigma_defeated", 
				"seraph_lumine_defeated", 
				"red_seen", 
				"red_defeated", 
				"serenade_seen", 
				"serenade_defeated"
			]
			for boss in end_bosses:
				if boss in variables:
					if boss == "vile3_defeated":
						btn.get_node("boss_icons").get_node("vile").get_node("animatedSprite").frame = 1
					if boss == "copy_sigma_defeated":
						btn.get_node("boss_icons").get_node("sigma").get_node("animatedSprite").frame = 1
					if boss == "seraph_lumine_defeated":
						btn.get_node("boss_icons").get_node("lumine").get_node("animatedSprite").frame = 1
					if boss == "red_seen":
						btn.get_node("boss_icons").get_node("red").visible = true
					if boss == "red_defeated":
						btn.get_node("boss_icons").get_node("red").get_node("animatedSprite").frame = 1
					if boss == "serenade_seen":
						btn.get_node("boss_icons").get_node("serenade").visible = true
					if boss == "serenade_defeated":
						btn.get_node("boss_icons").get_node("serenade").get_node("animatedSprite").frame = 1
		if data:
			if meta.has("difficulty"):
				var difficulty_text = ""
				var total_completion = 0
				if meta["difficulty"] == - 1:
					difficulty_text = "GAME_START_ROOKIE"
					total_completion = calculate_completion(collectibles, variables, max_collectibles - 6)
					btn.get_node("difficulty").idle_color = Color("#329632")
					btn.get_node("difficulty").focus_color = Color("#8cff8c")
				elif meta["difficulty"] == 0:
					difficulty_text = "GAME_START_NORMAL"
					total_completion = calculate_completion(collectibles, variables, max_collectibles)
					btn.get_node("difficulty").idle_color = Color("#68caff")
					btn.get_node("difficulty").focus_color = Color("#fbffaf")
				elif meta["difficulty"] == 1:
					difficulty_text = "GAME_START_HARD"
					total_completion = calculate_completion(collectibles, variables, max_collectibles - 2)
					btn.get_node("difficulty").idle_color = Color("#960000")
					btn.get_node("difficulty").focus_color = Color("#ff4b4b")
				elif meta["difficulty"] == 2:
					difficulty_text = "GAME_START_INSANITY"
					total_completion = calculate_completion(collectibles, variables, max_collectibles - 4)
					btn.get_node("difficulty").idle_color = Color("#771313")
					btn.get_node("difficulty").focus_color = Color("#ff7200")
				elif meta["difficulty"] == 3:
					difficulty_text = "GAME_START_NINJA"
					total_completion = calculate_completion(collectibles, variables, max_collectibles - 12)
					btn.get_node("difficulty").idle_color = Color("#832b7f")
					btn.get_node("difficulty").focus_color = Color("#e090f2")
				btn.completion.text = "Completion: %3.0f%%" % total_completion
				btn.difficulty.text = tr(difficulty_text)
			else:
				btn.difficulty.text = ""
				btn.completion.text = ""
			
			if meta.has("game_mode_set"):
				if not meta.get("game_mode_set", false):
					btn.difficulty.text = "not set"
					btn.get_node("difficulty").idle_color = Color.dimgray
					btn.get_node("difficulty").focus_color = Color.white
			else:
				btn.difficulty.text = "not set"

			var igt_string: = "0.0"
			if data.has("variables"):
				variables = data.get("variables", [])
				if variables.has("igt"):
					igt_string = igt_formatting(variables.get("igt", 0.0))

			var last_saved_string: = "-"
			if meta.has("last_saved"):
				last_saved_string = unix_to_string(meta.get("last_saved", 0))
			btn.last_saved.text = "IGT: " + igt_string + " - " + last_saved_string

			if meta.has("newgame_plus"):
				var new_plus = int(meta.get("newgame_plus", 0))
				if new_plus:
					if new_plus > 1:
						btn.newgame_plus.text = tr("NEWGAME_OPTION") + str(new_plus)
					else:
						btn.newgame_plus.text = tr("NEWGAME_OPTION")
				else:
					btn.newgame_plus.text = ""
			else:
				btn.newgame_plus.text = ""
		else:
			btn.difficulty.text = ""
			btn.completion.text = ""
			btn.last_saved.text = "-"
			btn.newgame_plus.text = ""

		btn._on_focus_exited()
		if slot_index == Savefile.save_slot:
			focus = btn

	var children: = save_button_container.get_children()
	var total: = children.size()
	for i in range(children.size()):
		var btn = children[i]
		if i == 0:
			btn.focus_neighbour_top = children[total - 1].get_path()
		else:
			btn.focus_neighbour_top = children[i - 1].get_path()

		if i < total - 1:
			btn.focus_neighbour_bottom = children[i + 1].get_path()
		else:
			btn.focus_neighbour_bottom = children[0].get_path()

func loaded_end() -> void :
	Savefile.load_save(Savefile.save_slot)
	emit_signal("loaded_savefile", CharacterManager.game_mode)
	lock_buttons()
	fader.FadeOut()
	yield(fader, "finished")
	GameManager.reset_stretch_mode()
	emit_signal("end")
	active = false

func _ready() -> void :
	load_all_slots()
	if get_parent().name == "root":
		start()
	else:
		menu.visible = false
		visible = true

func _input(event: InputEvent) -> void :
	if active and not locked:
		if exit_action != "none" and event.is_action_pressed(exit_action):
			end()

func start() -> void :
	load_all_slots()
	emit_signal("initialize")
	active = true
	emit_signal("lock_buttons")
	if start_emit_event != "none":
		Event.emit_signal(start_emit_event)
	fader.visible = true
	fader.FadeIn()
	GameManager.set_stretch_mode(SceneTree.STRETCH_MODE_2D)
	yield(fader, "finished")
	unlock_buttons()
	emit_signal("start")
	call_deferred("give_focus")

func give_focus() -> void :
	focus.silent = true
	focus.grab_focus()

func end() -> void :
	cancel.play()
	lock_buttons()
	fader.FadeOut()
	yield(fader, "finished")
	GameManager.reset_stretch_mode()
	emit_signal("end")
	active = false

func play_choice_sound() -> void :
	choice.play()

func play_loaded_sound() -> void :
	loaded.play()

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
