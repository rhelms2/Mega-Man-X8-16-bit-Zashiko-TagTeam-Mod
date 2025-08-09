extends AttackAbility

onready var space: Node = $"../Space"
onready var tween: = TweenController.new(self, false)
onready var shockwave: Sprite = $"../animatedSprite/shockwave"
onready var damagearea: Node2D = $damagearea
onready var feather_explosion: Particles2D = $"../feather_explosion"

onready var charge: AudioStreamPlayer2D = $charge
onready var fire: AudioStreamPlayer2D = $fire
onready var flap: AudioStreamPlayer2D = $flap
onready var thunder: AnimatedSprite = $"../animatedSprite/thunder"
onready var flash: Sprite = $flash

var floor_height = false

func _Setup():
	go_to_center()
	start_pursuit_tween()
	shockwave.scale = Vector2(0.25, 0.5)
	shockwave.modulate.a = 1.0
	shockwave.visible = false
	shockwave.self_modulate = Color.white

func start_pursuit_tween() -> void :
	tween.method("pursue_player", 0, 0.05, 1.2)
	tween.add_method("pursue_player", 0.05, 0.0, 0.2)

func pursue_player(percent: float) -> void :
	var distance = character.global_position.x - get_target()
	character.global_position.x = character.global_position.x - distance * percent
	
func emit_shockwave():
	thunder.frame = 0
	flash.start()
	feather_explosion.emitting = true
	shockwave.visible = true
	tween.attribute("scale", Vector2(0.5, 5.0), 0.2, shockwave)
	tween.attribute("modulate:a", 0.65, 0.35, shockwave)
	tween.add_attribute("modulate:a", 0, 0.2, shockwave)
	tween.attribute("self_modulate", Color.lightgreen, 0.25, shockwave)
	tween.add_attribute("self_modulate", Color.darkgreen, 0.25, shockwave)

func _Update(_delta):
	if attack_stage == 1:
		if not floor_height:
			floor_height = raycast_downward(1024)["position"].y
		play_animation("punch_prepare")
		charge.play()
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("punch_prepare_loop")
		next_attack_stage()
	
	elif attack_stage == 3 and timer > 0.5:
		next_attack_stage()
	
	elif attack_stage == 4 and timer > 0.2:
		force_movement(0)
		set_vertical_speed(900)
		play_animation("descent")
		next_attack_stage()
	
	elif attack_stage == 5:
		if character.global_position.y > floor_height or timer > 0.4:
			set_vertical_speed(0)
			fire.play_rp()
			emit_shockwave()
			Tools.timer(0.1,"activate",damagearea)
			#damagearea.activate()
			screenshake()
			if floor_height:
				character.global_position.y = floor_height - 32
			play_animation("punch")
			next_attack_stage()
	
	elif attack_stage == 6 and timer > 0.5:
		play_animation("punch_rise")
		next_attack_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("punch_rise_end")
		flap.play_rp()
		screenshake()
		turn_and_face_player()
		go_to_closest_position()
		next_attack_stage()
	
	elif attack_stage == 8 and has_finished_last_animation():
		play_animation_once("idle")
		
	elif attack_stage == 9:
		EndAbility()

func _Interrupt():
	tween.reset()
	._Interrupt()
	
func get_target() -> float:
	return GameManager.get_player_position().x

func go_to_center() -> void :
	var center = GameManager.camera.get_camera_screen_center() + Vector2(0, - 42)
	var time_to_return = 0.75
	turn_towards_point(center)
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_QUAD)
	tween.add_attribute("global_position:y", center.y, time_to_return, character)
	tween.add_callback("next_attack_stage")

func go_to_closest_position() -> void :
	var pos = space.get_closest_position()
	var time_to_return = 0.75
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("global_position:y", pos.y, time_to_return, character)
	tween.add_callback("next_attack_stage")

