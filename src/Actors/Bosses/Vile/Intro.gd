extends GenericIntro

export var boss_vile := false
const sprite_y := -19.0
onready var beam_in: AudioStreamPlayer2D = $beam_in

func set_dialogues():
	var _level_node = get_parent().get_parent().get_parent()
	
	var _level_name = _level_node.name
	
	if "BoosterForest" in _level_name:
		dialogue = CharacterManager._set_correct_dialogues("Vile Booster Forest", dialogue)
	if "Primrose" in _level_name:
		dialogue = CharacterManager._set_correct_dialogues("Vile Primrose", dialogue)
	
func _ready() -> void :
	._ready()
	set_dialogues()

func connect_start_events() -> void :
	Event.listen("vile_door_open", self, "prepare_for_intro")
	Event.listen("vile_door_exploded", self, "prepare_for_intro")
	Event.listen("vile_door_closed", self, "execute_intro")

func prepare_for_intro() -> void:
	animatedSprite.position = Vector2(0,-256)
	animatedSprite.frame = 0
	
func _Update(delta):
	process_gravity(delta)
	if attack_stage == 0 and timer > 0.5:
		Event.emit_signal("vile_intro")
		turn_player_towards_boss()
		turn_and_face_player()
		tween_attribute("position:y", sprite_y, 0.5, animatedSprite)
		beam_in.play()
		add_next_state(get_last_tween())
		next_attack_stage()
	
	elif attack_stage == 1:
		animatedSprite.frame = 0
	
	elif attack_stage == 2:
		play_animation_again("beam_in")
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("idle")
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.5:
		play_animation("laugh")
		next_attack_stage()
	
	elif attack_stage == 5 and timer > 0.25:
		start_dialog_or_go_to_attack_stage(7)
	
	elif attack_stage == 6:
		if timer > 1:
			play_animation_once("idle")
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 7:
		if boss_vile:
			Event.emit_signal("boss_health_appear", character)
			Event.emit_signal("play_boss_music")
			pass
		else:
			Event.emit_signal("play_miniboss_music")
		next_attack_stage()

	elif attack_stage == 8 and timer > 0.75:
		if boss_vile:
			if timer > 1.25:
				EndAbility()
				next_attack_stage()
		else:
			EndAbility()

func _Interrupt() -> void :
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	character.emit_signal("intro_concluded")
	if boss_vile:
		deactivate_air_attacks()

export  var ignore_deactivate: = false
func deactivate_air_attacks() -> void :
	if ignore_deactivate:
		return
	var air_attacks = [$"../VileAirCannon", $"../VileAirMissile", $"../VileAirDash", $"../VileAirKnee"]
	for attack in air_attacks:
		attack.deactivate()

func seen_dialog() -> bool:
	if GameManager.has_beaten_the_game():
		return true
	return .seen_dialog()
