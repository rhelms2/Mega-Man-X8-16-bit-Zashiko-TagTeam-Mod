extends AttackAbility
class_name BeeAttack

export var attack_velocity := 200

var target_direction := Vector2.ZERO
var reached_target := false
var current_vertical_speed := 0.0
onready var beepatrol := $"../BeePatrol"

func _ready() -> void:
# warning-ignore:return_value_discarded
	$"../DamageOnTouch".connect("touch_target", self, "on_touch_target")

func _Setup() -> void:
	._Setup()
	reached_target = false
	current_vertical_speed = 0.0

func on_touch_target() -> void:
	if executing:
		reached_target = true

func _Update(_delta):
	if attack_stage == 0 and has_finished_last_animation(): # mirando no player
		play_animation_once("attack")
		target_direction = (GameManager.get_player_position() - character.global_position).normalized()
		turn_and_face_player()
		next_attack_stage()

	if attack_stage == 1 and timer > 0.5: # pausa antes de investir
		next_attack_stage()

	elif attack_stage == 2: # setando velocidade da investida
		force_movement_regardless_of_direction(attack_velocity * target_direction.x) #equivalente a set_horizontal_speed
		set_vertical_speed(attack_velocity * target_direction.y)
		next_attack_stage()

	elif attack_stage == 3 and should_stop(): #parando se encostar no player ou cenario
		set_vertical_speed(0)
		force_movement(0)
		if timer > 1:
			play_animation_once("idle")
			current_vertical_speed = -100
			if global_position.y < beepatrol.patrol_position.y:
				current_vertical_speed = -30
			next_attack_stage()

	elif attack_stage == 4: # subindo de novo
		var tween = create_tween()
		tween.tween_property(self, "current_vertical_speed", 0.0, 1)
		set_vertical_speed(current_vertical_speed)
		
		if timer > 1:
			next_attack_stage()

	elif attack_stage == 5:
		set_vertical_speed(0)
		if timer > 0.5:
			EndAbility()

func should_stop() -> bool:
	
	if timer > 0.6:
		return true
	elif timer > 0.15:
		if reached_target or character.is_on_floor() or is_colliding_with_wall():
			return true
	return false
