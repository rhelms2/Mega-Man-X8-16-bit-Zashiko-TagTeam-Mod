extends AttackAbility

const crystal_height: float = 54.0

export  var crystal: PackedScene

onready var roar: AudioStreamPlayer2D = $roar

var desperation_direction: int = 1
var desperation_idle_time_base: int = 3
var desperation_idle_time: int = 3
var desperation_damage_reduction: float = 0.5
var max_waves: int = 6
var time_between_waves: Array = []
var time_interval: float = 1.5
var time_gap: float = 7.5
var crystal_speed: int = 200
var wave_interval: float = 0.1

signal ready_for_stun


func set_game_modes() -> void :
	if CharacterManager.game_mode < 0:
		max_waves = 6
		time_interval = 1.75
		time_gap = time_interval * 4
		crystal_speed = 180
	elif CharacterManager.game_mode == 0:
		max_waves = 6
		time_interval = 1.5
		time_gap = 7.5
		crystal_speed = 200
	elif CharacterManager.game_mode == 1:
		max_waves = 8
		time_interval = 1.3
		time_gap = time_interval * 4
		crystal_speed = 220
	elif CharacterManager.game_mode == 2:
		max_waves = 10
		time_interval = 1.25
		time_gap = time_interval * 4
		crystal_speed = 225
	elif CharacterManager.game_mode >= 3:
		max_waves = 12
		time_interval = 1.25
		time_gap = time_interval * 4
		crystal_speed = 240

func _Setup() -> void :
	desperation_idle_time = desperation_idle_time_base * CharacterManager.boss_ai_multiplier
	desperation_damage_reduction = CharacterManager.boss_damage_reduction
	turn_and_face_player()
	play_animation("rage_prepare")
	character.emit_signal("damage_reduction", desperation_damage_reduction)
	roar.play()
	Event.emit_signal("trilobyte_desperation")

func set_waves() -> void :
	time_between_waves.clear()
	time_between_waves.append(0.01)
	for i in range(1, max_waves):
		time_between_waves.append(time_interval * i)

func _Update(delta: float) -> void :
	process_gravity(delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("rage_loop")
		next_attack_stage()

	elif attack_stage == 1 and timer > 1:
		play_animation("rage_end")
		next_attack_stage()
		set_game_modes()
		set_waves()
		var rand_value = randi() %2
		if rand_value == 0:
			desperation_direction = 1
		else:
			desperation_direction = - 1
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("rage_to_idle")
		if not is_colliding_with_wall_on_direction(desperation_direction):
			next_attack_stage()
		else:
			go_to_attack_stage(6)

	elif attack_stage == 3 and has_finished_last_animation():
		set_direction(desperation_direction)
		play_animation("run_start")
		next_attack_stage()
	
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("run")
		force_movement(horizontal_velocity)
		next_attack_stage()
	
	elif attack_stage == 5:
		if is_colliding_with_wall_on_direction(desperation_direction):
			force_movement(0)
			next_attack_stage()

	elif attack_stage == 6:
		set_direction( - desperation_direction)
		play_animation("rage_prepare")
		next_attack_stage()

	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("desperation_prepare")
		next_attack_stage()

	elif attack_stage == 8 and has_finished_last_animation():
		play_animation("desperation")
		crystal_wave()
		next_attack_stage()
		if CharacterManager.game_mode < 2:
			emit_signal("ready_for_stun")
	
	elif attack_stage == 9:
		pass

	elif attack_stage == 10:
		play_animation("desperation_end")
		next_attack_stage()

	elif attack_stage == 11 and has_finished_last_animation():
		play_animation_once("idle")
		if timer > desperation_idle_time:
			EndAbility()

func _Interrupt() -> void :
	character.emit_signal("damage_reduction", 1.0)
	Event.emit_signal("trilobyte_desperation_end")

func crystal_wave() -> void :
	for i in range(min(max_waves, time_between_waves.size())):
		create_wave(time_between_waves[i], wave_interval)
	Tools.timer(time_between_waves[min(max_waves, time_between_waves.size()) - 1], "next_attack_stage", self)

func create_wave(initial_time: float, interval: float) -> void :
	Tools.timer(initial_time, "create_ground_crystal", self)
	Tools.timer(initial_time + interval, "create_second_ground_crystal", self)
	Tools.timer(initial_time + interval * time_gap, "create_ceiling_crystal", self)
	Tools.timer(initial_time + interval * (time_gap + 1.0), "create_second_ceiling_crystal", self)

func create_crystal(offset: Vector2 = Vector2.ZERO, inverted: bool = false) -> void :
	if not executing:
		return
	var c = instantiate(crystal)
	c.global_position += Vector2((offset.x - 32) * desperation_direction, offset.y)
	c.current_health = 20
	if inverted:
		c.scale.y = - 1
	c.initialize( - crystal_speed * desperation_direction)

func create_ground_crystal() -> void :
	create_crystal()

func create_second_ground_crystal() -> void :
	create_crystal(Vector2(0, - crystal_height - 4))

func create_ceiling_crystal() -> void :
	create_crystal(Vector2(32, - 116 - 16), true)

func create_second_ceiling_crystal() -> void :
	create_crystal(Vector2(32, - 58 - 16), true)
