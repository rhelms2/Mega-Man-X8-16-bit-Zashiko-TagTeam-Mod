class_name MultiShotWeapon extends BossWeapon

export  var number_of_shots: = 5
export  var speed: = 520
export  var step: = 140

var shot_number: = - floor(number_of_shots / 2)
var driftshoryuken
var executing: = false
onready var tween: = TweenController.new(self, false)
onready var weapon_stasis: Node2D = $"../../WeaponStasis"

func fire_regular() -> void :

	shot_number = - floor(number_of_shots / 2)
	play(weapon.sound)
	call_deferred("fire_spikes", speed, step, number_of_shots)

func fire_charged() -> void :
	play(weapon.charged_sound)
	var dir = character.get_facing_direction()
	var pos = Vector2(character.global_position.x + shot_position.position.x * dir, shot_position.global_position.y)
	var ss = instantiate_projectile(weapon.charged_shot)
	ss.global_position = pos
	

func fire_spikes(initial_speed: = 520, _step: = 140, times = 5):
	var _speed = Vector2(initial_speed, 0)
	var i = 0
	while i < times:
		fire_spike_and_adjust2(_speed, _step)
		i += 1
	
func fire_spike_and_adjust2(_speed, _step):
	var dir = character.get_facing_direction()
	var pos = Vector2(character.global_position.x + shot_position.position.x * dir, shot_position.global_position.y)
	var launch_speed = Vector2((_speed.x - abs(_step * shot_number)) * dir, _speed.y + (_step * shot_number))
	var shot = instantiate_projectile(weapon.regular_shot)
	shot.global_position = pos
	shot.set_horizontal_speed(launch_speed.x)
	shot.set_vertical_speed(launch_speed.y)
	if dir > 0:
		shot.get_node("animatedSprite").rotate(launch_speed.y / 330)
	else:
		shot.get_node("animatedSprite").rotate(launch_speed.y / - 330)
	shot_number += 1



