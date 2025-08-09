extends AttackAbility
class_name VileAirCannon

export var prepare_anim := "flight_cannon_prepare"
export var shot_anim := "flight_cannon_fire"
export var end_anim := "flight_cannon_end"
export var shots := 9
export var projectile : PackedScene
onready var tween := TweenController.new(self)
onready var space: Node = $"../Space"
signal stop
var moving = false
var headed_direction := 1
const steps := 1
onready var shot_sound: AudioStreamPlayer2D = $shot_sound
onready var traverse: AudioStreamPlayer2D = $traverse

func _Setup() -> void:
	play_animation("flight")
	turn_and_face_player()
	go_to_shot_position()
	traverse.play()

func _Update(_delta) -> void:
	keep_facing_player_while_flying()
	
	if attack_stage == 1:
		play_animation(prepare_anim)
		next_attack_stage()
	elif attack_stage > 1 and attack_stage <= shots and has_finished_last_animation():
		fire_projectile()
	
	elif attack_stage == shots + 1 and has_finished_last_animation():
		play_animation(end_anim)
		next_attack_stage()
	elif attack_stage == shots + 2 and has_finished_last_animation():
		play_animation("flight")
		EndAbility()

func _Interrupt() -> void:
	._Interrupt()
	emit_signal("stop")

func go_to_shot_position() -> void:
	moving = true
	var pos = space.get_random_position(character.global_position)
	var time_to_return = clamp(space.time_to_position(pos,150),0.75,1)
	tween.create(Tween.EASE_IN_OUT,Tween.TRANS_CUBIC,true)
	tween.add_attribute("global_position:x",pos.x,time_to_return,character)
	tween.create(Tween.EASE_IN, Tween.TRANS_SINE)
	if pos.y > character.global_position.y:
		tween.add_attribute("global_position:y",(pos.y + character.global_position.y)/2 + (16 * time_to_return),time_to_return/2,character)
	else:
		tween.add_attribute("global_position:y",pos.y+ (16 * time_to_return),time_to_return/2,character)		
	tween.set_ease(Tween.EASE_OUT, Tween.TRANS_SINE)
	#tween.set_sequential()
	tween.add_attribute("global_position:y",pos.y,time_to_return/2,character)
	tween.add_callback("ended_movement")
	tween.add_callback("next_attack_stage")
	headed_direction = get_position_direction(pos)

func get_position_direction(position_check) -> int:
	if position_check.x > character.global_position.x:
		return(1)
	else:
		return(-1)

func ended_movement() -> void:
	moving = false
	play_animation_once("flight")

func keep_facing_player_while_flying() -> void:
	if moving:
		turn_and_face_player()
		if headed_direction == get_player_direction_relative():
			if is_current_animation("flight"):
				play_animation_once("flight_to_jump")
			elif is_current_animation_either(["backwards","flight_to_backwards","jump_to_backwards"]):
				play_animation_once("backwards_to_jump")
			elif has_finished_either(["flight_to_jump","backwards_to_jump"]):
				play_animation_once("jump")
		else:
			if is_current_animation("flight"):
				play_animation_once("flight_to_backwards")
			elif is_current_animation_either(["jump","flight_to_jump","backwards_to_jump"]):
				play_animation_once("jump_to_backwards")
			elif has_finished_either(["flight_to_backwards","jump_to_backwards"]):
				play_animation_once("backwards")

func fire_projectile() -> void:
	play_animation_again(shot_anim)
	turn_and_face_player()
	shoot()
	shot_sound.play()
	next_attack_stage()
	
func shoot() -> void:
	var shot = instantiate_projectile(projectile)
	var spawn_position = Vector2(position.x * character.get_facing_direction(), position.y)
	var target_dir = get_player_angle(character.global_position + spawn_position)
	
	shot.global_position = character.global_position + spawn_position
	
	if "cannon" in shot_anim:
		if target_dir.x < 0.1 and target_dir.x > -0.1:
			target_dir.x = 0.0
		shot.set_horizontal_speed( 300 * target_dir.x)
		shot.set_vertical_speed( 300 * target_dir.y)
	else:
		shot.set_horizontal_speed( 300 * character.get_facing_direction())
		
func get_player_angle(global_position : Vector2) -> Vector2:
	var speed = clamp(GameManager.player.get_horizontal_speed(),-30,30)
	var player_pos = GameManager.get_player_position() + Vector2(speed,-5)
	
	return ((player_pos) - global_position).normalized()
	
