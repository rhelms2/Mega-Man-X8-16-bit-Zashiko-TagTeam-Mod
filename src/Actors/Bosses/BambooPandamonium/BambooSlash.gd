extends AttackAbility

const degrees: Array = [
			0, 90, - 45, 
		15, - 30, - 15, 
	- 45, 90, 15, 
	- 45, 30, 0, 
		90, - 15, 30, 
		45, 90, 0, 
	- 15, 30, 45, 
		30, 15, 90
]

export  var slash: PackedScene

onready var pandaslash: AudioStreamPlayer2D = $pandaslash
onready var roar: AudioStreamPlayer2D = $roar
onready var alert: AudioStreamPlayer2D = $alert
onready var claw_appear: AudioStreamPlayer2D = $claw_appear
onready var claw_retreat: AudioStreamPlayer2D = $claw_retreat

var current_degree: int = 0
var performed_slashes: int = 0
var alert_pitch: float = 0.5
var desperation_damage_reduction: float = 0.5

var max_slashes: int = 4
var slash_interval: Array = [0.454, 0.454, 0.454, 0.454, 0.454, 0.454, 0.454, 0.454]
var time_to_slash: Array = [1.55 - slash_interval[0], 1.22, 1.25, 1.22, 1.25, 1.22, 1.25, 1.22]
var wait_for_slash: Array = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
var time_after_slash: float = 0.5


signal cancel
signal slashed


func set_game_modes() -> void :
	desperation_damage_reduction = CharacterManager.boss_damage_reduction
	if CharacterManager.game_mode == 1:
		max_slashes = 6
		time_after_slash = 0.4
		slash_interval = [0.45, 0.45, 0.4, 0.4, 0.35, 0.35, 0.35, 0.35]
		time_to_slash = [1.05, 1.15, 1.02, 1.0, 0.72, 0.7, 0.72, 0.7]
		wait_for_slash = [0.47, 0.47, 0.42, 0.42, 0.32, 0.32, 0.32, 0.32]
	elif CharacterManager.game_mode == 2:
		max_slashes = 8
		time_after_slash = 0.25
		slash_interval = [0.4, 0.4, 0.37, 0.37, 0.3, 0.3, 0.25, 0.25]
		time_to_slash = [1.02, 1.0, 0.92, 0.9, 0.77, 0.75, 0.6, 0.6]
		wait_for_slash = [0.42, 0.42, 0.32, 0.32, 0.32, 0.32, 0.27, 0.27]
	elif CharacterManager.game_mode >= 3:
		max_slashes = 8
		time_after_slash = 0.25
		slash_interval = [0.4, 0.4, 0.37, 0.37, 0.3, 0.3, 0.25, 0.25]
		time_to_slash = [1.02, 1.0, 0.92, 0.9, 0.77, 0.75, 0.6, 0.6]
		wait_for_slash = [0.37, 0.37, 0.32, 0.32, 0.27, 0.27, 0.22, 0.22]
	
func _Setup() -> void :
	set_game_modes()
	current_degree = 0
	character.emit_signal("damage_reduction", desperation_damage_reduction)

func _Update(_delta: float) -> void :
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("rage_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 1 and timer > 0.227:
		play_animation("rage_start")
		claw_appear.play()
		roar.play()
		next_attack_stage()
		
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("rage_loop")
		next_attack_stage()
		
	
	elif attack_stage == 3 and timer > wait_for_slash[performed_slashes]:
		play_animation("slash_prepare")
		create_slashes()
		turn_and_face_player()
		next_attack_stage()
		
	
	elif attack_stage == 4 and has_finished_last_animation():
		play_animation("slash_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 5 and timer > time_to_slash[performed_slashes]:
		play_animation("slash1")
		activate_slashes()
		next_attack_stage()
	
	elif attack_stage == 6 and timer > wait_for_slash[performed_slashes]:
		play_animation("slash2_prepare")
		create_slashes()
		turn_and_face_player()
		next_attack_stage()
		
	elif attack_stage == 7 and has_finished_last_animation():
		play_animation("slash2_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 8 and timer > time_to_slash[performed_slashes]:
		play_animation("slash2")
		activate_slashes()
		if performed_slashes >= max_slashes:
			go_to_attack_stage(10)
		else:
			next_attack_stage()
		
	elif attack_stage == 9 and timer > wait_for_slash[performed_slashes]:
		play_animation("slash3_prepare")
		create_slashes()
		turn_and_face_player()
		go_to_attack_stage(4)

	
	elif attack_stage == 10 and timer > time_after_slash:
		play_animation("slash2_end")
		claw_retreat.play()
		next_attack_stage()
	
	elif attack_stage == 11 and has_finished_last_animation():
		EndAbility()
	
func activate_slashes() -> void :
	emit_signal("slashed")
	screenshake()
	pandaslash.play()
	performed_slashes += 1
	
func create_slashes() -> void :
	create_slash()
	Tools.timer(slash_interval[performed_slashes], "create_slash", self)
	Tools.timer(slash_interval[performed_slashes] * 2, "create_slash", self)

func create_slash() -> void :
	if executing:
		var s = instantiate(slash)
		s.global_position = GameManager.get_player_position()
		s.rotate_degrees(degrees[current_degree])
		var _d = connect("slashed", s, "activate")
		_d = connect("cancel", s, "queue_free")
		current_degree += 1
		play_alert()

func play_alert() -> void :
	alert.pitch_scale = alert_pitch
	alert.play()
	alert_pitch += 0.12
	if alert_pitch >= 0.5 + 0.12 * 3:
		alert_pitch = 0.5
	

func _Interrupt() -> void :
	performed_slashes = 0
	character.emit_signal("damage_reduction", 1.0)
	emit_signal("cancel")
	._Interrupt()
