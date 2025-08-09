extends GenericIntro

onready var floppy: Node2D = $"../Floppy"
export  var bar: Texture
onready var battle_song: AudioStreamPlayer = $BattleSong

func _ready() -> void :
	call_deferred("play_animation", "analysing")
	Event.listen("character_talking", self, "talk")
	floppy.call_deferred("appear")

func talk(character):
	if executing:
		if character == "Secret3":
			play_animation_once("analysing_talk")
		else:
			play_animation_once("analysing")

func connect_start_events() -> void :
	Log("Connecting boss door events")
	Event.listen("teleport_to_red", self, "prepare_for_intro")
	Event.listen("end_teleport_to_red", self, "execute_intro")

func _Setup():
	GlobalVariables.set("red_seen", true)
	turn_player_towards_boss()
	GameManager.start_cutscene()
	GameManager.dialog_box.emit_capsule_signal = false
	next_attack_stage()

func _Update(_delta):
	if attack_stage == 1 and timer > 2:
		start_dialog_or_go_to_attack_stage(3)

	elif attack_stage == 2:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 3:
		floppy.disappear()
		battle_song.play()
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.7:
		play_animation("analysing_end")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.7:
		play_animation("turn")
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.7:
		play_animation("ready")
		Event.emit_signal("set_boss_bar", bar)
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()
		
	elif attack_stage == 7 and timer > 1:
		EndAbility()
