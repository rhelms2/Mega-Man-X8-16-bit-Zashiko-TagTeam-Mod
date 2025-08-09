extends AttackAbility
onready var space: Node = $"../Space"
onready var tween := TweenController.new(self)
var time_to_return := 1.0
signal stop
onready var light_vfx: AnimatedSprite = $Hitbox/area2D/collisionShape2D/light_vfx
onready var hitbox: Node2D = $Hitbox
onready var bolt: AudioStreamPlayer2D = $bolt
onready var move: AudioStreamPlayer2D = $"../move"

func _Update(_delta) -> void:
	if attack_stage == 0:
		play_animation("move_down")
		go_to_nearest_position_besides_player()
		next_attack_stage()
		move.play_rp()
	
	# attack_stage == 1 is tween
	
	elif attack_stage == 2:
		play_animation("light_prepare")
		hitbox.handle_direction()
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("light")
		bolt.play_rp()
		light_vfx.visible = true
		light_vfx.frame = 0
		hitbox.activate()
		next_attack_stage()
		
	elif attack_stage == 4 and timer > .5:
		play_animation("light_stop")
		light_vfx.visible = false
		next_attack_stage()
	
	elif attack_stage == 5 and timer > .25:
		play_animation("light_end")
		go_to_closest_position()
		move.play_rp()
		next_attack_stage()
	
	elif attack_stage == 6 and has_finished_last_animation():
		play_animation_once("idle")
		next_attack_stage()
		
	elif attack_stage == 7 and timer > time_to_return:
		EndAbility()

func _Interrupt() -> void:
	emit_signal("stop")
	light_vfx.visible = false

func go_to_nearest_position_besides_player() -> void:
	var pos = GameManager.get_player_position() 
	pos.x += 64 * - get_player_direction_relative()
	var travel_duration = clamp(space.time_to_position(pos) /2,0.65,2.0)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position",pos,travel_duration,character)
	tween.add_callback("next_attack_stage")
	tween.add_callback("turn_and_face_player")

func go_to_closest_position() -> void:
	var pos = space.get_closest_position()
	time_to_return = space.time_to_position(pos)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_SINE)
	tween.add_attribute("global_position",pos,time_to_return,character)
	
