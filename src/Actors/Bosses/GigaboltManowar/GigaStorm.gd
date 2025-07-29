extends AttackAbility

export  var vertical_offset: float = 10.0
export  var strong_lightining: PackedScene
export  var damage_reduction_during_desperation: float = 0.5

onready var space: Node = $"../Space"
onready var tween: TweenController = TweenController.new(self)
onready var raycasts: Array = [$check, $check2, $check3, $check4, $check5]
onready var spin: AudioStreamPlayer2D = $spin
onready var lightning_sfx: AudioStreamPlayer2D = $lightning
onready var move: AudioStreamPlayer2D = $"../move"
onready var flash: Sprite = get_node("flash")

var travel_duration: float = 1.0
var cast_times: int = 0
var current_lightnings: Array
var current_crystal_walls: Array
var sequence0: Array = [
	[1], 
	[3], 
	[5], 
	[4, 5], 
	[1, 2], 
	[1], 
	[1, 2], 
	[1, 2, 3]
]
var sequence1: Array = [
	[3], 
	[2, 4], 
	[1, 5], 
	[2, 4], 
	[3], 
	[2, 4], 
	[1, 3, 5], 
	[2, 4]
]
var sequence: Array = [
	[1, 3, 5], 
	[2, 4], 
	[1, 4, 5], 
	[1, 2, 4], 
	[3, 5], 
	[2, 4], 
	[1, 3, 5], 
	[2, 3, 4]
]
var sequence2: Array = [
	[1, 4], 
	[2, 3, 5], 
	[1, 4, 5], 
	[1, 3, 5], 
	[2, 4], 
	[2, 5], 
	[1, 2, 3], 
	[1, 4, 5]
]
var sequence3: Array = [
	[2, 5], 
	[1, 3, 5], 
	[2, 3, 5], 
	[2, 4], 
	[1, 3, 5], 
	[1, 5], 
	[2, 3, 4], 
	[1, 3, 5]
]
var sequences: Array = [sequence0, sequence1, sequence, sequence2, sequence3]
var current_sequence
var final_storms: Array
var desperation_damage_reduction: float = 0.5

var storm_prepare_time: Array = [0.45, 0.45, 0.45, 0.45]
var strom2_time: Array = [1.25, 0.65]
var storm3_time: Array = [1.5, 0.65, 0.65]
var storm_stop_time: float = 1.0
var extra_warning_delay: float = 0.5
var sequence_chance = [0, 20, 20, 20, 20, 20]

signal stop
signal ready_for_stun


func set_game_modes() -> void :
	desperation_damage_reduction = CharacterManager.boss_damage_reduction
	if CharacterManager.game_mode < 0:
		storm_prepare_time = [0.5, 0.5, 0.5, 0.5]
		strom2_time = [1.5, 0.7]
		storm3_time = [1.5, 0.7, 0.7]
		storm_stop_time = 1.25
		extra_warning_delay = 0.5
		sequences = [sequence0, sequence1, generate_random_sequence(2, 3, 2, 2, 0, 0, 1.0, false)]
	elif CharacterManager.game_mode == 0:
		storm_prepare_time = [0.45, 0.45, 0.45, 0.45]
		strom2_time = [1.25, 0.65]
		storm3_time = [1.5, 0.65, 0.65]
		storm_stop_time = 1.0
		extra_warning_delay = 0.5
		sequences = [sequence, sequence2, sequence3]
	elif CharacterManager.game_mode == 1:
		storm_prepare_time = [0.45, 0.45, 0.4, 0.4]
		strom2_time = [1.25, 0.6]
		storm3_time = [1.5, 0.6, 0.6]
		storm_stop_time = 1.0
		extra_warning_delay = 0.5
		sequences = [sequence, sequence2, sequence3, generate_random_sequence(2, 3, 3, 3, 0, 0, 1.0, false)]
	elif CharacterManager.game_mode == 2:
		storm_prepare_time = [0.4, 0.4, 0.4, 0.4]
		strom2_time = [1.1, 0.55]
		storm3_time = [1.25, 0.55, 0.55]
		storm_stop_time = 0.8
		extra_warning_delay = 0.4
		sequences = [generate_random_sequence(2, 4, 3, 3, 1, 0, 1.0, false)]
	elif CharacterManager.game_mode >= 3:
		storm_prepare_time = [0.4, 0.35, 0.3, 0.2]
		strom2_time = [1.0, 0.5]
		storm3_time = [1.1, 0.5, 0.5]
		storm_stop_time = 0.6
		extra_warning_delay = 0.4
		var seq = generate_random_sequence(3, 5, 3, 3, 1, 1, 0.0, false)
		sequences = [seq]

func generate_random_sequence(
	min_length: int = 1, 
	max_length: int = 5, 
	max_simple_length: int = 3, 
	min_complex_length: int = 3, 
	max_count_4: int = 1, 
	max_count_5: int = 1, 
	side_switch_strength: float = 1.0, 
	can_repeat: bool = true
) -> Array:
	var simple_phase_end_index: int = 3
	var complex_phase_start_index: int = 4
	var total_entries: int = 8
	var sequence: Array = []
	var count_4: int = 0
	var count_5: int = 0
	
	if min_length < 1:
		min_length = 1
	if max_length > 5:
		max_length = 5
	if min_length > max_length:
		min_length = max_length
	
	for i in range(total_entries):
		var entry = []
		var attempts = 0
		
		while attempts < 100:
			var number_pool: Array = [1, 2, 3, 4, 5]
			number_pool.shuffle()
			
			var phase_min = min_length
			var phase_max = max_length
			if i <= simple_phase_end_index:
				phase_max = min(max_simple_length, max_length)
			if i >= complex_phase_start_index:
				phase_min = max(min_complex_length, min_length)
			var length = phase_min
			if phase_max > phase_min:
				length = randi() %(phase_max - phase_min + 1) + phase_min
				
			entry = []
			for j in range(length):
				entry.append(number_pool[j])
			entry.sort()
			
			if i > 0 and entry == sequence[i - 1]:
				attempts += 1
				continue
			if not can_repeat and entry in sequence:
				attempts += 1
				continue
			
			if i > 0 and entry.size() < sequence[i - 1].size():
				var is_subset: = true
				for n in entry:
					if not sequence[i - 1].has(n):
						is_subset = false
						break
				if is_subset:
					attempts += 1
					continue
			
			if i > 0 and side_switch_strength > 0.0:
				var last_avg = 0.0
				for n in sequence[i - 1]:
					last_avg += n
				last_avg /= sequence[i - 1].size()
				var current_avg = 0.0
				for n in entry:
					current_avg += n
				current_avg /= entry.size()
				if abs(current_avg - last_avg) < side_switch_strength:
					attempts += 1
					continue
			
			if i <= simple_phase_end_index and entry.size() > max_simple_length:
				attempts += 1
				continue
			if i >= complex_phase_start_index and entry.size() < min_complex_length:
				attempts += 1
				continue
				
			if entry.size() == 4:
				if count_4 >= max_count_4 or count_5 > 0:
					attempts += 1
					continue
			if entry.size() == 5:
				if count_5 >= max_count_5 or count_4 > 0:
					attempts += 1
					continue
			
			if entry.size() == 4:
				count_4 += 1
			elif entry.size() == 5:
				count_5 += 1
				
			break
		sequence.append(entry)
	return sequence

func _ready() -> void :
	Event.connect("crystal_wall_created", self, "on_wall_created")

func on_wall_created(wall) -> void :
	current_crystal_walls.append(wall)

func _Setup() -> void :
	set_game_modes()
	character.emit_signal("damage_reduction", desperation_damage_reduction)
	cast_times = 0
	pick_random_storm_sequence()
	for cast in raycasts:
		cast.enabled = true

func pick_random_storm_sequence() -> void :
	if sequences.size() == 0:
		current_sequence = sequence
		return
	current_sequence = sequences[randi() %sequences.size()]

func _Update(_delta: float) -> void :
	if attack_stage == 0:
		turn_and_face_player()
		play_animation("roll_prepare")
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation_once("roll_start")
		spin.play()
		next_attack_stage()
			
	elif attack_stage == 2 and timer > 0.75:
		play_animation("thunder_loop")
		shake()
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 0.45:
		play_animation("intro")
		next_attack_stage()
		
	elif attack_stage == 4 and timer > 0.65:
		play_animation("move_up")
		move.play_rp()
		go_to_center()
		next_attack_stage()
		
	elif attack_stage == 5 and timer > travel_duration:
		next_attack_stage()
		
	
	elif attack_stage == 6:
		play_animation("storm_prepare")
		cast_warnings()
		next_attack_stage()
		if CharacterManager.game_mode < 2:
			emit_signal("ready_for_stun")
		
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("storm_start")
		next_attack_stage()
		
	elif attack_stage == 8 and has_finished_last_animation():
		play_animation("storm_loop")
		cast_storm()
		next_attack_stage()
		
	elif attack_stage == 9 and timer > storm_stop_time:
		play_animation("storm_stop")
		next_attack_stage()
		
	elif attack_stage == 10 and timer > storm_prepare_time[cast_times - 1]:
		if cast_times < 3:
			go_to_attack_stage(6)
		else:
			play_animation("storm_prepare")
			cast_extra_warnings()
			next_attack_stage()

	
	elif attack_stage == 11 and timer > strom2_time[0]:
		play_animation("storm_start")
		next_attack_stage()
		
	elif attack_stage == 12 and has_finished_last_animation():
		play_animation("storm_loop")
		cast_final_storm()
		next_attack_stage()
		
	elif attack_stage == 13 and timer > strom2_time[1]:
		play_animation("storm_start")
		next_attack_stage()
		
	elif attack_stage == 14 and has_finished_last_animation():
		play_animation("storm_loop")
		cast_final_storm()
		next_attack_stage()
		
	elif attack_stage == 15 and timer > storm_stop_time:
		play_animation("storm_stop")
		next_attack_stage()
		
	
	elif attack_stage == 16 and timer > storm_prepare_time[3]:
		play_animation("storm_prepare")
		final_storms.clear()
		cast_extra_warnings(true)
		next_attack_stage()
	
	elif attack_stage == 17 and timer > storm3_time[0]:
		play_animation("storm_start")
		next_attack_stage()
		
	elif attack_stage == 18 and has_finished_last_animation():
		play_animation("storm_loop")
		cast_final_storm()
		next_attack_stage()
		
	elif attack_stage == 19 and timer > storm3_time[1]:
		play_animation("storm_start")
		next_attack_stage()
		
	elif attack_stage == 20 and has_finished_last_animation():
		play_animation("storm_loop")
		cast_final_storm()
		next_attack_stage()
		
	elif attack_stage == 21 and timer > storm3_time[2]:
		play_animation("storm_start")
		next_attack_stage()
		
	elif attack_stage == 22 and has_finished_last_animation():
		play_animation("storm_loop")
		cast_final_storm()
		next_attack_stage()
	
	elif attack_stage == 23 and timer > storm_stop_time:
		play_animation("storm_stop")
		next_attack_stage()
	
	
	elif attack_stage == 24 and has_finished_last_animation():
		turn_towards_point(space.get_closest_position())
		play_animation("storm_end")
		next_attack_stage()
		
	elif attack_stage == 25 and has_finished_last_animation():
		play_animation("move_down")
		move.play_rp()
		go_to_closest_position()
		next_attack_stage()
	
	elif attack_stage == 26 and timer > travel_duration:
		EndAbility()

func cast_warnings() -> void :
	current_lightnings.clear()
	for element in current_sequence[cast_times]:
		create_lightning(raycasts[element - 1].get_collision_point())
	cast_times += 1

func cast_final_warnings() -> void :
	current_lightnings.clear()
	var pack: Array
	for element in current_sequence[cast_times]:
		pack.append(create_lightning(raycasts[element - 1].get_collision_point(), 0.35))
	cast_times += 1
	final_storms.append(pack)

func create_lightning(collision_point, warning: float = 0.75) -> Node2D:
	var lightning: StrongLightning = strong_lightining.instance()
	lightning.global_position = character.global_position
	get_tree().current_scene.add_child(lightning)
	lightning.position_end(collision_point)
	lightning.update_joints()
	lightning.prepare(warning)
	current_lightnings.append(lightning)
	var _s = lightning.connect("expired", self, "remove_lightning")
	return lightning

func cast_extra_warnings(final: bool = false) -> void :
	cast_final_warnings()
	Tools.timer(extra_warning_delay, "cast_final_warnings", self)
	if final:
		Tools.timer(extra_warning_delay * 2, "cast_final_warnings", self)

func cast_storm() -> void :
	lightning_sfx.play_rp()
	screenshake()
	if has_valid_crystal_wall():
		cast_special_lightning()
		break_wall()
		for light in current_lightnings:
			light.expire()
			remove_lightning(light)
		return
	for light in current_lightnings:
		light.start_lightning()
	if flash != null:
		flash.start()

func cast_final_storm() -> void :
	lightning_sfx.play_rp()
	screenshake()
	if has_valid_crystal_wall():
		cast_special_lightning()
		final_storms.pop_front()
		if final_storms.size() == 0:
			break_wall()
		return
	for light in final_storms.pop_front():
		if final_storms.size() > 0:
			light.damage_duration = 0.35
		light.start_lightning()
	if flash != null:
		flash.start()

func has_valid_crystal_wall() -> bool:
	for wall in current_crystal_walls:
		if is_instance_valid(wall) and wall.active and not wall.shattered:
			return true
	return false

func cast_special_lightning() -> void :
	var wall = get_crystal_wall()
	if wall:
		create_lightning(wall.global_position, 0.0).call_deferred("start_lightning")

func get_crystal_wall():
	for wall in current_crystal_walls:
		if is_instance_valid(wall) and not wall.shattered:
			return wall

func break_wall():
	var wall = get_crystal_wall()
	if wall:
		wall.break_crystal()
		current_crystal_walls.erase(wall)

func shake() -> void :
	pass

func remove_lightning(light) -> void :
	current_lightnings.erase(light)

func go_to_closest_position() -> void :
	var destination = space.get_closest_position()
	travel_duration = space.time_to_position(destination, 120)
	turn_towards_point(destination)
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("global_position", destination, travel_duration, character)

func go_to_center() -> void :
	var destination = space.center + Vector2(0, vertical_offset)
	travel_duration = space.time_to_position(destination, 120)
	turn_towards_point(destination)
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE, false)
	tween.add_attribute("global_position", destination, travel_duration, character)

func _Interrupt() -> void :
	emit_signal("stop")
	character.emit_signal("damage_reduction", 1.0)
	for r in current_lightnings:
		r.queue_free()
	current_lightnings.clear()
