extends Node

export  var dialogue: Resource
var started: = false

func _ready() -> void :
	if not started:
		Event.listen("gameplay_start", self, "start")
		

func start():
	dialogue = CharacterManager._set_correct_dialogues(name, dialogue)
	if not GameManager.was_dialogue_seen(dialogue):
		if GameManager.player:
			GameManager.player.deactivate()
			if GameManager.player.name == "X":
				GameManager.player.reactivate_charge()
		GameManager.start_dialog(dialogue)
	else:
		if not started:
			start_gameplay()

func start_gameplay():
	if GameManager.player:
		GameManager.player.activate()
	started = true
	
	Event.emit_signal("gameplay_start")


func _on_dialog_concluded() -> void :
	if not started:
		start_gameplay()
