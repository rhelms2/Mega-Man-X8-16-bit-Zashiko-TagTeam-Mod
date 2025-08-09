extends GenericIntro

export var slash : PackedScene
onready var bamboo: Node2D = $Bamboo
onready var bamboo_2: Node2D = $Bamboo2
onready var bamboo_3: Node2D = $Bamboo3
onready var bamboo_4: Node2D = $Bamboo4
onready var bamboos = [bamboo, bamboo_2, bamboo_3, bamboo_4]
onready var bamboo_sprites : Array
onready var bamboo_deaths : Array
onready var alert: AudioStreamPlayer2D = $alert
onready var pandaslash: AudioStreamPlayer2D = $pandaslash
onready var claw_appear: AudioStreamPlayer2D = $claw_appear
onready var claw_retreat: AudioStreamPlayer2D = $claw_retreat

signal slashed

func _ready() -> void:
	for b in bamboos:
		for object in b.get_children():
			if object is AnimatedSprite:
				bamboo_sprites.append(object)
			else:
				bamboo_deaths.append(object)

func prepare_for_intro() -> void:
	make_invisible()
	for b in bamboos:
		b.visible = true

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and timer > 0.6:
		create_slash()
		next_attack_stage()
		
	elif attack_stage == 1 and timer >= 0.454:
		alert.pitch_scale += 0.12
		alert.play()
		next_attack_stage()

	elif attack_stage == 2 and timer >= 0.454:
		alert.pitch_scale += 0.12
		alert.play()
		next_attack_stage()

	elif attack_stage == 3 and timer >= 0.454:
		pandaslash.play()
		turn_player_towards_boss()
		screenshake()
		emit_signal("slashed")
		for d in bamboo_deaths:
			d.activate()
		for b in bamboo_sprites:
			b.visible = false
		animatedSprite.modulate = Color(1,1,1,1)
		turn_and_face_player()
		play_animation_again("appear")
		Tools.timer(0.75,"play",claw_retreat)
		next_attack_stage()

	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("idle")
		start_dialog_or_go_to_attack_stage(6)
		
	elif attack_stage == 5:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 6:
		Event.emit_signal("play_boss_music")
		play_animation("intro_start")
		Tools.timer(0.45,"play",claw_appear)
		next_attack_stage()
		
	elif attack_stage == 7 and timer > 0.5:
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()

	elif attack_stage == 8 and timer > 1.5:
		play_animation("intro_end")
		claw_retreat.play()
		next_attack_stage()
	
	elif attack_stage == 9 and has_finished_last_animation():
		play_animation("idle")
		EndAbility()

func _Interrupt() -> void:
	Event.emit_signal("boss_start", character)
	GameManager.end_cutscene()
	character.emit_signal("intro_concluded")

func create_slash() -> void:
	var s = instantiate(slash)
	s.rotate_degrees(15)
	s.global_position.y += 24
	alert.play()
	var _d = connect("slashed",s,"activate")
