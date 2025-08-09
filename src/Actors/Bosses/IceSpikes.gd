extends AttackAbility
class_name IceSpikes

export(PackedScene) var spikes
export var initial_spikes_position := Vector2(50, 20)
onready var arms = $arms

func _Update(_delta):
	if attack_stage == 0 and timer > 0.4:
		arms.play()
		next_attack_stage_on_next_frame()
			
	if attack_stage == 1 and has_finished_last_animation():
		play_animation_once("icespikes")
		fire_spikes()
		next_attack_stage_on_next_frame()

	elif attack_stage == 2 and has_finished_last_animation():
		EndAbility()
	
func _Interrupt():
	play_animation_once("icespikes_end")

func fire_spikes(initial_speed := 520, step := 45):
	var speed = Vector2(initial_speed, 0)
	speed = fire_spike_and_adjust(speed, step)
	speed = fire_spike_and_adjust(speed, step)
	speed = fire_spike_and_adjust(speed, step)
	speed = fire_spike_and_adjust(speed, step)
	speed = fire_spike_and_adjust(speed, step)

func fire_spike_and_adjust(speed, step) -> Vector2:
	var pos = Vector2(initial_spikes_position.x * character.get_facing_direction(), initial_spikes_position.y)
	var launch_speed = Vector2(speed.x * character.get_facing_direction(), speed.y)
	fire(spikes, pos, 0 , launch_speed)
	return Vector2 (speed.x - step, speed.y - step)
	
