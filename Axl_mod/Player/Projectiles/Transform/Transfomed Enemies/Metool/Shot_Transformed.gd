extends AttackAbility
export (PackedScene) var projectile
onready var shot_sound: AudioStreamPlayer2D = $shot_sound

onready var tracker: Area2D = get_parent().get_node("tracker")
var target: Node2D
var target_dir: Vector2

func _StartCondition() -> bool:
	if Input.is_action_pressed(actions[0]):
		if character.get_animation() == "idle":
			return true
	return false

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation_once("shot")
		shot_sound.play()
		shoot_towards_nearest_enemy(projectile)
		next_attack_stage_on_next_frame()
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("idle")
		EndAbility()

func shoot_towards_nearest_enemy(projectile) -> void :
	target = tracker.get_closest_target()
	if is_instance_valid(target):
		target_dir = Tools.get_angle_between(target, self)
	else:
		target_dir = Vector2(character.animatedSprite.scale.x, 0)
		
	var shot = instantiate(projectile)
	shot.initialize( - character.get_facing_direction())
	shot.set_creator(self)
	shot.set_horizontal_speed(100 * target_dir.x)
	shot.set_vertical_speed(100 * target_dir.y)
		
