extends AttackAbility

onready var tween := TweenController.new(self,false)
export var unique_start_time := 0.5
#const preload("res://src/Actors/Bosses/CopyReploid/transform_reploid.res")
func _ready() -> void:
	connect_start_events()
	#call_deferred("prepare_for_intro")
	#call_deferred("execute_intro")
	character.listen("death",self,"deactivate")

func connect_start_events() -> void:
	Log("Connecting boss door events")
	#Event.listen("boss_door_open",self,"prepare_for_intro")
	#Event.listen("boss_door_exploded",self,"prepare_for_intro")
	#Event.listen("warning_done",self,"execute_intro")

func prepare_for_intro() -> void:
	Log("Preparing for Intro")
	animatedSprite.position.y = -200
	#make_invisible()

func execute_intro() -> void:
	ExecuteOnce()

func _Setup():
	GameManager.start_cutscene()

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and timer > unique_start_time:
		play_animation("fall")
		descent()
		next_attack_stage()
	
	#attack_stage == 1 is descent
	
	elif attack_stage == 2:
		play_animation("land")
		next_attack_stage()

	elif attack_stage == 3 and timer > 2:
		play_animation("transform_start")
		next_attack_stage()
		pass

	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("select_loop")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 2:
		play_animation("transform")
		next_attack_stage()
		
	#Event.emit_signal("play_boss_music")
	#Event.emit_signal("boss_health_appear", character)
	#EndAbility()

func descent():
	tween.create(Tween.EASE_IN, Tween.TRANS_SINE)
	tween.add_attribute("position:y",0.0,2.0,animatedSprite)
	tween.add_callback("next_attack_stage")

func _Interrupt():
	#Event.emit_signal("boss_start", character)
	#GameManager.end_cutscene()
	character.emit_signal("intro_concluded")

	
func _EndCondition() -> bool:
	return false

