extends AttackAbility

export var _wind : PackedScene
export var _ball : PackedScene
onready var raycast: RayCast2D = $"../animatedSprite/rayCast2D"
onready var punch: AudioStreamPlayer2D = $punch

func _ready() -> void:
	pass

func _Setup() -> void:
	turn_and_face_player()
	raycast.enabled = true
	play_animation("punch_prepare")

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0 and timer > 0.5:
		play_animation("punch")
		punch.play_rp()
		create_wind()
		create_ball()
		screenshake()
		next_attack_stage()
	
	elif attack_stage == 1 and timer > 0.5:
		play_animation("punch_recover")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	raycast.enabled = false

func create_wind():
	var wind = _wind.instance()
	get_tree().current_scene.add_child(wind)
	wind.global_position = Vector2(global_position.x + 24 * get_facing_direction(), global_position.y + 3)
	wind.set_direction(get_facing_direction())
	
func create_ball():
	var ball = _ball.instance()
	get_tree().current_scene.add_child(ball)
	ball.global_position = raycast.get_collision_point() - Vector2(24 * get_facing_direction(), 0)
	if is_player_above(48):
		ball.rotation_degrees = 90
