extends GenericIntro
onready var riding_vile: AnimatedSprite = $"../vile"
onready var flying_vile: AnimatedSprite = $"../flying_prop_vile"
onready var tween := TweenController.new(self,false)
onready var startup: AudioStreamPlayer2D = $"../startup"
onready var step: AudioStreamPlayer2D = $"../step"
onready var land: Particles2D = $"../land"
onready var traverse: AudioStreamPlayer2D = $"../flying_prop_vile/traverse"
onready var punch: AudioStreamPlayer2D = $"../punch"
onready var wind: Sprite = $"../animatedSprite/wind"

func prepare_for_intro() -> void:
	dialogue = CharacterManager._set_correct_dialogues("Vile Final", dialogue)
	riding_vile.visible = false
	flying_vile.visible = false
	flying_vile.position.y = -160
	flying_vile.scale.x = -1
	play_animation("deactivated")

func connect_start_events() -> void:
	Log("Connecting boss door events")
	Event.listen("vile_door_open",self,"prepare_for_intro")
	Event.listen("vile_door_exploded",self,"prepare_for_intro")
	Event.listen("vile_door_closed",self,"execute_intro")

func _ready() -> void:
	call_deferred("prepare_for_intro")

func _Update(delta):
	process_gravity(delta)
	if attack_stage == 0 and timer > 1:
		flying_vile.visible = true
		traverse.play_rp(0.05,0.82)
		tween.create(Tween.EASE_OUT, Tween.TRANS_QUAD)
		tween.add_attribute("position:y",-40,1.5,flying_vile)
		tween.add_callback("next_attack_stage")
		next_attack_stage()
		
	#attack_stage == 1 is flying_vile descent
		
	elif attack_stage == 2:
		play_animation("activate")
		startup.play()
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("idle")
		tween.create(Tween.EASE_IN, Tween.TRANS_QUAD)
		tween.add_attribute("position:y",-0,0.5,flying_vile)
		tween.add_callback("next_attack_stage")
		next_attack_stage()
		
	#attack_stage == 4 is flying_vile descent
	
	elif attack_stage == 5:
		riding_vile.visible = true
		flying_vile.visible = false
		play_animation("recover")
		land.restart()
		step.play()
		start_dialog_or_go_to_attack_stage(7)
	
	elif attack_stage == 6:
		if seen_dialog():
			next_attack_stage()


	elif attack_stage == 7:
		Event.emit_signal("play_miniboss_music")
		next_attack_stage()
		
	elif attack_stage == 8 and timer > 0.75:
		animatedSprite.speed_scale = 1.5
		play_animation("punch_1")
		punch.play_rp()
		wind.emit()
		Tools.timer(0.25,"second_punch",self)
		next_attack_stage()
		
	elif attack_stage == 9 and has_finished_last_animation():
		play_animation("punch_3")
		wind.emit()
		punch.play_rp(0.05,0.8)
		next_attack_stage()
		
	elif attack_stage == 10 and has_finished_last_animation():
		animatedSprite.speed_scale = 1
		play_animation("punch_end")
		next_attack_stage()
		
	elif attack_stage == 11 and timer > 0.5:
		play_animation("idle")
		EndAbility()

func second_punch():
	wind.emit()
	punch.play_rp()
	
