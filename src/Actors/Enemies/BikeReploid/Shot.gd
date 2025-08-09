extends AttackAbility

const timer_between_shots := 0.5
const total_shots := 5
var shots_fired := 0
export var projectile : PackedScene
onready var shot_origin: Node2D = $"../animatedSprite/shot_origin"

var tween

func _Setup() -> void:
	shots_fired = 0
	tween = create_tween()
	tween.tween_method(self,"force_movement",get_actual_speed(),horizontal_velocity,0.5) # warning-ignore:return_value_discarded 

func _Update(_delta) -> void:
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("shot")
		fire_shot()
		next_attack_stage()
	if attack_stage == 1 and timer > timer_between_shots:
		if shots_fired < total_shots:
			go_to_attack_stage(0)
		else:
			play_animation_once("shot_end")
			next_attack_stage()
	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()

func _Interrupt() -> void:
	force_movement(horizontal_velocity)
	play_animation("idle")
	if tween:
		tween.kill()

func _EndCondition() -> bool:
	return abs(get_distance_to_player()) > 240

func fire_shot() -> void:
	var p = instantiate_projectile(projectile)
	p.global_position = shot_origin.global_position
	p.set_horizontal_speed(100 * -character.get_facing_direction())
	shots_fired += 1
