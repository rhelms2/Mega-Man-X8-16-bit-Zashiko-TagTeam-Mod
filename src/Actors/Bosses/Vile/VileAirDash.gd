extends AttackAbility

onready var tween: = TweenController.new(self, false)
onready var rise: AudioStreamPlayer2D = $rise
onready var traverse: AudioStreamPlayer2D = $traverse
onready var land: AudioStreamPlayer2D = $land

var ended_movement: = false
onready var space: Node = $"../Space"
onready var dash_particles: Particles2D = $dash_particles

func _Setup() -> void :
	play_animation("flight_to_upward")
	turn_and_face_player()
	ended_movement = false

func _Update(_delta: float) -> void :
	if attack_stage == 0:
		turn_and_face_player()
		move_slightly_upwards(45)
		rise.play()
		next_attack_stage()

	elif attack_stage == 1:
		if has_finished_animation("flight_to_upward"):
			play_animation_once("upward")
		elif has_finished_animation("upward"):
			play_animation_once("upward_to_flight")
		elif has_finished_animation("upward_to_flight"):
			play_animation_once("flight")
		if timer > 0.75:
			play_animation("flight_to_jump")
			dash_towards_player()
			traverse.play()
			next_attack_stage()

	elif attack_stage == 2 and character.is_on_floor():
		play_animation("dash_start")
		collided_with_ground()
		land.play()
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("dash")
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.25:
		play_animation("dash_end")
		slide()
		dash_particles.emitting = false
		next_attack_stage()

	elif attack_stage == 5 and ended_movement:
		play_animation("idle_to_flight")
		move_slightly_upwards(120)
		rise.play()
		turn_and_face_player()
		next_attack_stage()

	elif attack_stage == 6:
		if has_finished_last_animation():
			play_animation_once("flight")
		if timer > 0.75:
			EndAbility()

func dash_towards_player() -> void :
	tween.create(Tween.EASE_OUT, Tween.TRANS_CUBIC)
	tween.add_method("force_movement", 0.0, 380.0, 0.75)
	tween.create(Tween.EASE_IN, Tween.TRANS_CUBIC)
	tween.add_method("set_vertical_speed", 300, 800.0, 0.75)

func collided_with_ground() -> void :
	tween.reset()
	force_movement(400)
	dash_particles.emitting = true

func slide() -> void :
	tween.reset()
	tween.create()
	tween.add_method("force_movement", 200, 0.0, 0.4)
	Tools.timer(0.5, "end_movement", self)

func move_slightly_upwards(amount = 100) -> void :
	tween.create(Tween.EASE_IN, Tween.TRANS_CUBIC)
	tween.add_method("set_vertical_speed", - amount, 0.0, 0.5)

func end_movement() -> void :
	ended_movement = true

func _Interrupt() -> void :
	._Interrupt()
	tween.reset()
	dash_particles.emitting = false
