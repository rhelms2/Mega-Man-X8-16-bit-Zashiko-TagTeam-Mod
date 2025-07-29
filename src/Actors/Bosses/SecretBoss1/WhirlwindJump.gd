extends AttackAbility
onready var smoke_dash: Particles2D = $"../animatedSprite/smoke_dash"
onready var raycast: RayCast2D = $"../animatedSprite/rayCast2D2"
onready var jump: AudioStreamPlayer2D = $jump
onready var shot: AudioStreamPlayer2D = $shot_sound
onready var dash: AudioStreamPlayer2D = $dash
onready var land: AudioStreamPlayer2D = $land

export var _ball : PackedScene

func _Setup() -> void:
	turn_and_face_player()
	play_animation("backward_prepare")
	raycast.enabled = true
	next = 0

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("dash_backward")
		dash.play()
		smoke_dash.emitting = true
		force_movement(-500)
		next_attack_stage()
	
	if attack_stage == 1 and timer > 0.1 and character.is_colliding_with_wall():
		smoke_dash.emitting = false
		play_animation("jump_prepare")
		decay_speed_regardless_of_direction()
		next_attack_stage()
	
	elif attack_stage == 2 and timer > 0.5:
		play_animation("jump")
		jump.play()
		force_movement(311) #250 -450
		set_vertical_speed(-435)
		Tools.timer(0.25,"fire_whirlwind",self)
		Tools.timer(0.5,"fire_whirlwind",self)
		Tools.timer(0.75,"fire_whirlwind",self)
		next_attack_stage()
	
	elif attack_stage == 3 and character.is_on_floor():
		play_animation("jump_land")
		land.play()
		decay_speed_regardless_of_direction()
		turn()
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()

func fire_whirlwind():
	if executing:
		play_animation_again("jump_shot")
		create_ball()
		shot.play()

var next: = 0
var angles = [0, 90, 0]

func create_ball():
	var ball = _ball.instance()
	get_tree().current_scene.add_child(ball)
	ball.global_position = raycast.get_collision_point() - Vector2(0, 24)
	ball.rotation_degrees = angles[next]
	next += 1

func _Interrupt():
	._Interrupt()
	raycast.enabled = false
	smoke_dash.emitting = false
