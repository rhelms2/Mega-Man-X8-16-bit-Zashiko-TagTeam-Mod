extends GenericIntro

export var boss_bar : Texture
onready var throne: TileMap = $"../Throne"
onready var throne_particles: Particles2D = $"../throne_particles"
onready var throne_explosion: AudioStreamPlayer2D = $"../throne_explosion"
onready var flash: Sprite = $flash

func connect_start_events() -> void:
	Log("Connecting boss events")
	Event.listen("warning_done",self,"execute_intro")
	Event.connect("character_talking",self,"on_talk")

func on_talk(character):
	if character == "Sigma":
		play_animation_once("talk")
	else:
		play_animation_once("seated_loop")
		pass

func _ready() -> void:
	call_deferred("play_animation","seated_loop")
	

func _Update(_delta) -> void:
	if attack_stage == 0:
		play_animation("seated_loop")
		start_dialog_or_go_to_attack_stage(2)

	elif attack_stage == 1:
		if seen_dialog():
			next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.1:
		next_attack_stage()
	
	elif attack_stage == 3 and timer > 0.25:
		play_animation("intro")
		Event.emit_signal("play_boss_music")
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("intro2")
		flash.start()
		Event.emit_signal("sigma_walls")
		throne.queue_free()
		throne_explosion.play()
		throne_particles.emitting = true
		screenshake()
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("intro_loop")
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.65:
		Event.emit_signal("set_boss_bar",boss_bar)
		Event.emit_signal("boss_health_appear", character)
		next_attack_stage()

	elif attack_stage == 7 and timer > 1.55:
		play_animation("intro_end")
		next_attack_stage()
		
	elif attack_stage == 8 and has_finished_last_animation():
		EndAbility()
