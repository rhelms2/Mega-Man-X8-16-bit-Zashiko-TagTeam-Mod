extends AttackAbility

onready var tween: TweenController = TweenController.new(self)
onready var step_sfx: AudioStreamPlayer2D = $step

var ignore: bool = true #bandaid to fix screenshake at start
var distance_to_player: int = 240
var step_speed: Array = [0.65, 0.55]
var speed_multiplier: float = 1.15
var screenshake_intensity: float = 0.8
var target_dir: Vector2 = Vector2.ZERO

signal stop


func set_game_modes() -> void :
	if CharacterManager.game_mode <= - 1:
		distance_to_player = 300
		step_speed = [0.75, 0.65]
		horizontal_velocity = 400
		speed_multiplier = 1.15
		screenshake_intensity = 0.8
	if CharacterManager.game_mode == 0:
		distance_to_player = 240
		step_speed = [0.65, 0.55]
		horizontal_velocity = 420
		speed_multiplier = 1.15
		screenshake_intensity = 0.8
	if CharacterManager.game_mode == 1:
		distance_to_player = 200
		step_speed = [0.55, 0.45]
		horizontal_velocity = 450
		speed_multiplier = 1.25
		screenshake_intensity = 0.9
	if CharacterManager.game_mode == 2:
		distance_to_player = 150
		step_speed = [0.5, 0.4]
		horizontal_velocity = 500
		speed_multiplier = 1.5
		screenshake_intensity = 1.0
	if CharacterManager.game_mode >= 3:
		distance_to_player = 100
		step_speed = [0.45, 0.35]
		horizontal_velocity = 520
		speed_multiplier = 1.5
		screenshake_intensity = 1.2

func _ready() -> void :
	set_game_modes()

func _Setup() -> void :
	if ignore:
		ignore = false
		return
	set_game_modes()
	step()
	play_animation("walk_start")
	set_player_direction()

func _Update(delta: float) -> void :
	process_gravity(delta * 6.5)
	
	if attack_stage == 0 and timer > get_time_between_steps():
		play_animation("walk_step")
		step()
		next_attack_stage()
		
	elif attack_stage == 1 and timer > get_time_between_steps():
		play_animation("walk_step2")
		step()
		go_to_attack_stage(0)

func _Interrupt() -> void :
	emit_signal("stop")
	force_movement(0)

func get_time_between_steps() -> float:
	if distance_from_player() > distance_to_player and is_player_in_front():
		return step_speed[1]
	return step_speed[0]

func get_pursuit_speed() -> float:
	if distance_from_player() > distance_to_player:
		return horizontal_velocity * speed_multiplier
	return horizontal_velocity

func step_sound_and_screenshake() -> void :
	step_sfx.play()
	screenshake(screenshake_intensity)

func distance_from_player() -> float:
	return abs(global_position.x - GameManager.get_player_position().x)

func step() -> void :
	tween.method("force_movement", 0.0, get_pursuit_speed(), 0.2)
	tween.add_callback("step_sound_and_screenshake")
	tween.add_method("force_movement", horizontal_velocity, 0.0, 0.2)

func set_player_direction() -> void :
	var player_position = GameManager.get_player_position()
	target_dir = (player_position - global_position).normalized()
	if player_position.x < global_position.x:
		character.set_direction( - 1)
		character.update_facing_direction()
	else:
		character.set_direction(1)
		character.update_facing_direction()
