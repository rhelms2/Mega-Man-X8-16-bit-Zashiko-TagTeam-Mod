extends AttackAbility

export  var damage_reduction: = 0.5
var desperation_finished: = false
onready var lightnings: = [$VileLightning, $VileLightning3, $VileLightning5]
onready var lightnings2: = [$VileLightning2, $VileLightning4, $VileLightning6]
onready var space: Node = $"../Space"
onready var tween: = TweenController.new(self)
onready var lightning: AudioStreamPlayer2D = $lightning
onready var warning: AudioStreamPlayer2D = $warning
onready var lightning_loop: AudioStreamPlayer2D = $lightning_loop
onready var end: AudioStreamPlayer2D = $end
onready var flash: Sprite = $flash

signal stop
signal ready_for_stun

var desperation_damage_reduction: float = 0.5
var lighting_pattern: Dictionary = {
		"ease": Tween.EASE_IN_OUT, 
		"trans": Tween.TRANS_CUBIC, 
		"sequence": [
			{"angle": 45, "time": 2.0, "callback": "flicker_1"}, 
			{"angle": - 45, "time": 2.0, "callback": "flicker_2"}, 
			{"angle": 25, "time": 2.0, "callback": "flicker_1"}, 
			{"angle": - 45, "time": 2.0, "callback": "flicker_2"}, 
			{"angle": 45, "time": 2.0, "callback": "flicker_1"}, 
			{"angle": 0, "time": 1.5, "callback": "finished_rotating"}
		]
	}
var flicker_pattern: Array = [0.1, 0.1, 0.3, 0.1, 0.1]
var flicker_repeats: int = 0

func set_game_modes() -> void :
	if CharacterManager.game_mode <= - 1:
		flicker_repeats = 0
		flicker_pattern = [0.1, 0.1, 0.3, 0.1, 0.1]
		lighting_pattern = {
			"ease": Tween.EASE_IN_OUT, 
			"trans": Tween.TRANS_SINE, 
			"sequence": [
				{"angle": 45, "time": 2.5, "callback": "flicker_1"}, 
				{"angle": - 45, "time": 2.5, "callback": "flicker_2"}, 
				{"angle": 45, "time": 2.5, "callback": "flicker_1"}, 
				{"angle": - 45, "time": 2.5, "callback": "flicker_2"}, 
				{"angle": 45, "time": 2.5, "callback": "flicker_1"}, 
				{"angle": 0, "time": 2.0, "callback": "finished_rotating"}
			]
		}
	if CharacterManager.game_mode == 0:
		flicker_repeats = 0
		flicker_pattern = [0.1, 0.1, 0.3, 0.1, 0.1]
		lighting_pattern = {
			"ease": Tween.EASE_IN_OUT, 
			"trans": Tween.TRANS_CUBIC, 
			"sequence": [
				{"angle": 45, "time": 2.0, "callback": "flicker_1"}, 
				{"angle": - 45, "time": 2.0, "callback": "flicker_2"}, 
				{"angle": 25, "time": 2.0, "callback": "flicker_1"}, 
				{"angle": - 45, "time": 2.0, "callback": "flicker_2"}, 
				{"angle": 45, "time": 2.0, "callback": "flicker_1"}, 
				{"angle": 0, "time": 1.5, "callback": "finished_rotating"}
			]
		}
	if CharacterManager.game_mode == 1:
		flicker_repeats = 100
		flicker_pattern = [0.6, 0.3, 0.3]
		lighting_pattern = generate_lighting_pattern(Tween.EASE_IN_OUT, Tween.TRANS_CUBIC, [45, 90, 180], 15.0, 1.0, flicker_pattern)
	if CharacterManager.game_mode == 2:
		flicker_repeats = 100
		flicker_pattern = [0.5, 0.25, 0.25]
		lighting_pattern = generate_lighting_pattern(Tween.EASE_IN_OUT, Tween.TRANS_SINE, [90, 180, 270, 360], 20.0, 0.7, flicker_pattern)
	if CharacterManager.game_mode >= 3:
		flicker_repeats = 100
		flicker_pattern = [0.3, 0.15, 0.15]
		lighting_pattern = generate_lighting_pattern(Tween.EASE_IN_OUT, Tween.TRANS_SINE, [180, 225, 270, 315, 360], 25.0, 0.6, flicker_pattern)

func generate_lighting_pattern(
	_ease: = Tween.EASE_IN, 
	_trans: = Tween.TRANS_LINEAR, 
	angle_steps: Array = [45, 90, 135, 180, 225, 270, 315, 360], 
	max_total_time: float = 10.0, 
	time_per_45: float = 0.625, 
	flicker_time: Array = [0.1, 0.1, 0.2]
	) -> Dictionary:
	var sequence = []
	var current_angle = 0
	var direction = 1
	var delay = 0.0
	for t in flicker_time:
		delay += t
	delay /= 2
	delay += 0.05
	sequence.append({"angle": 0, "time": 0.0, "callback": "flicker_1"})
	sequence.append({"angle": 0, "time": delay, "callback": "flicker_2"})
	
	var total_time = delay
	
	while true:
		var next_step = angle_steps[randi() %angle_steps.size()]
		var next_angle = next_step * direction
		var angle_diff = abs(next_angle - current_angle)
		var duration = (angle_diff / 45.0) * time_per_45
		
		if total_time + duration > max_total_time:
			break

		sequence.append({"angle": next_angle, "time": duration, "callback": "at_center"})
		total_time += duration
		
		if time_per_45 < 1.0:
			sequence.append({"angle": next_angle, "time": time_per_45, "callback": "_pause_"})
			total_time += time_per_45
		
		current_angle = next_angle
		direction *= - 1

	var return_diff = abs(current_angle - 0)
	if return_diff == 0:
		return_diff = 360
	var return_time = (return_diff / 45.0) * time_per_45
	sequence.append({"angle": 0, "time": return_time, "callback": "finished_rotating"})
	return {
		"ease": _ease, 
		"trans": _trans, 
		"sequence": sequence
	}

func _Setup() -> void :
	desperation_damage_reduction = CharacterManager.boss_damage_reduction / 2
	character.emit_signal("damage_reduction", desperation_damage_reduction)
	deactivate_ground_attacks()
	activate_air_attacks()
	desperation_finished = false

func _Update(_delta: float) -> void :
	if attack_stage == 0:
		play_animation("idle_to_flight")
		move_upward()
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("flight_to_upward")
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("upward")
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 0.25:
		play_animation("upward_to_flight")
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("flight")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > 0.45:
		go_to_center()
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 1.25:
		play_animation("shock_prepare")
		warning_shot()
		warning.play()
		next_attack_stage()

	elif attack_stage == 7 and has_finished_last_animation():
		set_game_modes()
		play_animation("shock")
		screenshake()
		flash.start()
		lightning.play()
		lightning_loop.play()
		activate_lightning()
		next_attack_stage()

	elif attack_stage == 8 and desperation_finished:
		play_animation("shock_idle")
		emit_signal("ready_for_stun")
		end.play()
		lightning_loop.stop()
		end_lightning()
		next_attack_stage()
		
	elif attack_stage == 9 and timer > 1.0:
		play_animation("shock_to_flight")
		next_attack_stage()
		
	elif attack_stage == 10 and has_finished_last_animation():
		play_animation_once("flight")
		if timer > 1:
			EndAbility()

func warning_shot() -> void :
	for l in lightnings:
		l.prepare()
	for l in lightnings2:
		l.prepare()

func activate_lightning() -> void :
	setup_rotation(lighting_pattern)
	for l in lightnings:
		l.activate()
	for l in lightnings2:
		l.activate()















	
func setup_rotation(config: Dictionary) -> void :
	var _ease = config.get("ease", Tween.EASE_IN_OUT)
	var _trans = config.get("trans", Tween.TRANS_CUBIC)
	var sequence = config.get("sequence", [])
	tween.create(_ease, _trans)
	for step in sequence:
		var angle = step.get("angle", 0)
		var time = step.get("time", 1.0)
		var callback = step.get("callback", null)
		tween.add_attribute("rotation_degrees", angle, time)
		if callback != null:
			tween.add_callback(callback)

func flicker_1() -> void :
	for l in lightnings:
		l.flicker_pattern = flicker_pattern
		l.flicker(flicker_repeats)
		
func flicker_2() -> void :
	for l in lightnings2:
		l.flicker_pattern = flicker_pattern
		l.flicker(flicker_repeats)

func finished_rotating() -> void :
	desperation_finished = true

func end_lightning() -> void :
	for l in lightnings:
		l.finish()
	for l in lightnings2:
		l.finish()

func deactivate_lightning() -> void :
	for l in lightnings:
		l.deactivate()
	for l in lightnings2:
		l.deactivate()

func move_upward() -> void :
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_CUBIC)
	tween.add_attribute("global_position:y", character.global_position.y - 64, 1.25, character)

func go_to_center() -> void :
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_CUBIC)
	var final_pos = space.get_center()
	final_pos.y += 8
	tween.add_attribute("global_position", final_pos, 1.25, character)
	tween.add_callback("at_center")

func at_center() -> void :
	pass

func _Interrupt() -> void :
	emit_signal("stop")
	lightning_loop.stop()
	deactivate_lightning()
	character.emit_signal("damage_reduction", 1)

func deactivate_ground_attacks() -> void :
	var ground_attacks = [$"../VileJump", $"../VileDash", $"../VileCannon", $"../VileMissiles"]
	for attack in ground_attacks:
		attack.deactivate()

func activate_air_attacks() -> void :
	var air_attacks = [$"../VileAirCannon", $"../VileAirMissile", $"../VileAirDash"]
	for attack in air_attacks:
		attack.activate()
