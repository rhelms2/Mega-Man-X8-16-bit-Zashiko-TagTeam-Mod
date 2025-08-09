extends AttackAbility

export var projectile : PackedScene
onready var space: Node = $"../Space"

func _Setup() -> void:
	turn_towards_point(space.center)

func _Update(_delta):
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("spin_start")
		force_movement(120)
		next_attack_stage()
	elif attack_stage == 1 and has_finished_last_animation():
		queue_balls()
		play_animation("spin")
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 1.25:
		play_animation("spin_stop")
		turn_and_face_player()
		decay_speed_regardless_of_direction()
		next_attack_stage()
	elif attack_stage == 3 and has_finished_last_animation():
		EndAbility()
		pass
	pass

func queue_balls():
	var i = 0
	while i < 10:
		Tools.timer(0.1 + (0.1*i),"create_ball",self)
		i += 1

func create_ball():
	if executing:
		var ball = projectile.instance()
		var center = space.center + Vector2(0,64)
		get_tree().current_scene.add_child(ball)
		ball.position = global_position + Vector2(0,-8)
		ball.move(center + Vector2(rand_range(-160,160),rand_range(-30,100)))
		ball.z_index = 0
		ball.modulate.a = 0.5
		Tools.timer_p(0.15,"set_z_index",ball,15)
		Tools.timer_p(0.15,"set_modulate",ball,Color.white)
