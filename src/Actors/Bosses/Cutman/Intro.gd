extends GenericIntro
onready var battle_song: AudioStreamPlayer = $BattleSong
onready var arrive: AnimatedSprite = $"../arrive"
onready var land: AudioStreamPlayer2D = $land

func connect_start_events() -> void:
	Event.listen("teleport_to_secret1",self,"prepare_for_intro")
	Event.listen("end_teleport_to_secret1",self,"execute_intro")

func prepare_for_intro() -> void:
	Log("Preparing for Intro")
	make_invisible()

func make_visible() -> void:
	animatedSprite.modulate = Color(1,1,1,1)
	pass
	
func _ready() -> void:
	arrive.connect("animation_finished",self,"make_visible")
	pass

func _Setup():
	turn_player_towards_boss()
	GameManager.start_cutscene()

func _Update(_delta) -> void:
	process_gravity(_delta)
	if timer > 1.75 and attack_stage == 0:
		battle_song.play()
		next_attack_stage()
	
	elif timer > 1.65 and attack_stage == 1:
		arrive.playing = true
		land.play()
		next_attack_stage()
		
	elif timer > 1.5 and attack_stage == 2:
		EndAbility()
