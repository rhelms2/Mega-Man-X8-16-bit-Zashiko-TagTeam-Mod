extends AttackAbility
class_name VileShot

export  var projectile: PackedScene
export  var shots: int = 1
export  var initial_speed: Vector2
export  var shoot_towards_player: bool = false

onready var shot_sound: AudioStreamPlayer2D = $shot_sound

var anim_name: String


func _Setup() -> void :
	._Setup()
	anim_name = animation.trim_suffix("_prepare")

func _Update(_delta: float) -> void :
	turn_and_face_player()
	if attack_stage < shots and has_finished_last_animation():
		fire_projectile()
	elif attack_stage == shots and has_finished_last_animation():
		play_animation_once(anim_name + "_end")
		next_attack_stage()
	elif attack_stage == shots + 1 and has_finished_last_animation():
		EndAbility()

func fire_projectile() -> void :
	play_animation_again(anim_name + "_fire")
	shoot(projectile)
	shot_sound.play()
	next_attack_stage()

func shoot(_projectile) -> void :
	var shot = instantiate_projectile(_projectile)
	var target_dir = Tools.get_player_angle(global_position)
	var spawn_position = Vector2(position.x * character.get_facing_direction(), position.y)
	shot.global_position = character.global_position + spawn_position
	if shoot_towards_player:
		if target_dir.x < 0.2 and target_dir.x > - 0.2:
			target_dir.x = 0.0
		shot.set_horizontal_speed(initial_speed.x * target_dir.x)
		shot.set_vertical_speed(initial_speed.y * target_dir.y)
	else:
		shot.set_horizontal_speed(initial_speed.x * character.get_facing_direction())
