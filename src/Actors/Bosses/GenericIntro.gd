extends AttackAbility
class_name GenericIntro

export  var skip_intro: bool = false
export  var manual_start: bool = false
export  var dialogue: Resource
export  var defeated_var: String = "_none"

var dialog_concluded: = false
var collectible: = "_undefined"


func _ready() -> void :
	dialogue = CharacterManager._set_correct_dialogues(get_parent().name, dialogue)
	setup_collectible_name()
	if not skip_intro:
		if not manual_start:
			connect_start_events()
		if dialogue:
			call_deferred("connect_dialogue")
	else:
		call_deferred("prepare_for_intro")
		call_deferred("execute_intro")
	character.listen("death", self, "deactivate")

func setup_collectible_name() -> void :
	var bossdeath = character.get_node_or_null("BossDeath")
	if bossdeath != null and "collectible" in bossdeath:
		collectible = bossdeath.collectible

func connect_start_events() -> void :
	Log("Connecting boss door events")
	Event.listen("boss_door_open", self, "prepare_for_intro")
	Event.listen("boss_door_exploded", self, "prepare_for_intro")
	Event.listen("warning_done", self, "execute_intro")
	
func connect_dialogue() -> void :
	GameManager.dialog_box.connect("dialog_concluded", self, "on_concluded_dialog")

func on_concluded_dialog() -> void :
	dialog_concluded = true

func prepare_for_intro() -> void :
	make_invisible()

func make_invisible() -> void :
	animatedSprite.modulate = Color(1, 1, 1, 0.01)
	
func make_visible() -> void :
	animatedSprite.modulate = Color(1, 1, 1, 1)

func execute_intro() -> void :
	ExecuteOnce()

func _Setup():
	GameManager.start_cutscene()

func _Update(_delta: float) -> void :
	make_visible()
	Event.emit_signal("play_boss_music")
	Event.emit_signal("boss_health_appear", character)
	EndAbility()

func _Interrupt():
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	character.emit_signal("intro_concluded")

func _EndCondition() -> bool:
	return false

func start_dialog_or_go_to_attack_stage(skip_dialog_stage: = 0) -> void :
	if not seen_dialog():
		GameManager.start_dialog(dialogue)
		next_attack_stage()
	elif seen_dialog():
		go_to_attack_stage(skip_dialog_stage)

func seen_dialog() -> bool:
	if collectible in GameManager.collectibles:
		return true
	if defeated_var != "_none" and GlobalVariables.get(defeated_var):
		return true
	return GameManager.was_dialogue_seen(dialogue)
