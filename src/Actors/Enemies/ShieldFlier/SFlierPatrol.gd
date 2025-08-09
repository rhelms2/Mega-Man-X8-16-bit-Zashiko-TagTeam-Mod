extends AttackAbility
class_name SFlierPatrol

export var travel_speed := 60.0
export var travel_duration := 2.65
var distance_limit := 160.0
#var tween
var current_speed := 0.0
var moving := false

onready var tween := TweenController.new(self,false)

var initial_pos : Vector2

func _ready() -> void:
	initial_pos = global_position

func is_beyond_limit() -> bool:
	if get_facing_direction() > 0:
		return global_position.x > initial_pos.x + distance_limit
	else:
		return global_position.x < initial_pos.x - distance_limit

func _Setup():
	moving = false
	pass

func _Update(_delta) -> void:
	if attack_stage == 0: #andando
		if not moving:
			tween.attribute("current_speed", travel_speed, 0.75)
			moving = true
		play_animation_once("idle")
		force_movement(current_speed)
		if is_beyond_limit():
			next_attack_stage()
	
	elif attack_stage ==1: 
		if moving:
			tween.attribute("current_speed", 0.0, 0.35)
			moving = false
		play_animation_once("turn")
		force_movement(current_speed)
		
		if has_finished_last_animation() and timer > 0.4:
			play_animation_once("idle")
# warning-ignore:narrowing_conversion
			set_direction(character.get_direction() * -1)
			go_to_attack_stage_on_next_frame(0)

func _Interrupt():
	._Interrupt()
	tween.reset()
