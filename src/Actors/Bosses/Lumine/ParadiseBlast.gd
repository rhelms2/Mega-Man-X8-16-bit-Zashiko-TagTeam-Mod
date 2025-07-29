extends AttackAbility

onready var space: Node = $"../Space"
onready var tween: = TweenController.new(self, false)
onready var flash: Sprite = $flash
onready var feather_explosion: Particles2D = $"../feather_explosion"
onready var cannon: Node2D = $cannon
onready var vfx: AnimatedSprite = $"../animatedSprite/cannon"
onready var fire: AudioStreamPlayer2D = $fire
onready var charge: AudioStreamPlayer2D = $charge

var pursuing: = false
var offset: = 64.0

func _Setup():
	pursuing = true
	turn_and_face_player()
	go_to_nearest_position_besides_player()
	start_pursuit_tween()
	
func start_pursuit_tween() -> void:
	tween.method("pursue_player",0,.17,1.2)
	tween.add_method("pursue_player",.15,0.0,.2)

func pursue_player(percent: float) -> void :
	var distance = character.global_position.x - get_target()
	character.global_position.x = character.global_position.x - distance * percent
	
	
func get_target() -> float:
	var player = GameManager.get_player_position()
	return player.x - 64 * get_facing_direction()

var lerpi: = 0.0

func _Update(delta):
	if attack_stage == 1:
		play_animation("blast_prepare")
		charge.play_rp()
		next_attack_stage()

	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("blast_prepare_loop")
		next_attack_stage()
	
	elif attack_stage == 3 and timer > 0.7:
		pursuing = false
		cannon.handle_direction()
		set_horizontal_speed(0)
		next_attack_stage()
	
	elif attack_stage == 4 and timer > 0.25:
		play_animation("blast_loop")
		cannon.activate()
		fire.play()
		vfx.play("cannon_loop")
		flash.start()
		screenshake()
		Tools.timer(0.6, "screenshake", self)
		feather_explosion.restart()
		force_movement( - 16)
		set_vertical_speed( - 8)
		next_attack_stage()
	
	elif attack_stage == 5 and timer > 0.7:
		cannon.deactivate()
		vfx.play("cannon_end")
		play_animation("blast_prepare_loop")
		decay_speed()
		decay_vertical_speed()
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.45:
		play_animation("blast_end")
		next_attack_stage()
	
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("idle")
		go_to_closest_position()
		next_attack_stage()
		
	elif attack_stage == 9:
		EndAbility()

func _Interrupt():
	cannon.deactivate()
	vfx.play("cannon_end")
	tween.reset()
	._Interrupt()

func go_to_nearest_position_besides_player() -> void:
	var pos = space.get_bottom() - 32
	var travel_duration = 0.5
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("global_position:y", pos, travel_duration, character)
	tween.add_callback("next_attack_stage")
	tween.add_callback("turn_and_face_player")

func go_to_closest_position() -> void :
	var pos = space.get_closest_position()
	var time_to_return = .4
	#turn_towards_point(pos)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position:y",pos.y,time_to_return,character)
	tween.add_callback("next_attack_stage")
