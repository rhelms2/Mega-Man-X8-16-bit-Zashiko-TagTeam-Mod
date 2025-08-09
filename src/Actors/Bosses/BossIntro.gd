extends EnemyAbility
class_name BossIntro

export var skip_intro := false
export var show_health := true

func _ready() -> void:
	if not skip_intro:
		connect_events()
	else:
		call_deferred("prepare_for_intro")
		call_deferred("execute_intro")
	character.listen("death",self,"deactivate")

func connect_events() -> void:
	Event.listen("boss_door_open",self,"prepare_for_intro")
	Event.listen("boss_cutscene_start",self,"execute_intro")

func prepare_for_intro() -> void:
	animatedSprite.visible = false
	
func _Setup():
	if not skip_intro:
		GameManager.start_cutscene()

func _Update(_delta) -> void:
	Event.emit_signal("play_boss_music")
	Event.emit_signal("boss_start", character)
	if show_health:
		Event.emit_signal("boss_health_appear", character)
	EndAbility()

func _Interrupt():
	if not skip_intro:
		GameManager.end_cutscene()
		animatedSprite.visible = true
	character.emit_signal("intro_concluded")

func execute_intro() -> void:
	ExecuteOnce()
	
func _EndCondition() -> bool:
	return false
