extends AttackAbility

onready var tween: TweenController = TweenController.new(self)
onready var damage_area: Node2D = $damage_area
onready var drill: AudioStreamPlayer2D = $drill

var end_time: float = 0.65
var loop_time: float = 1.0

signal stop


func set_game_modes() -> void :
	if CharacterManager.game_mode <= - 1:
		end_time = 0.65
		loop_time = 1.2
	if CharacterManager.game_mode == 0:
		end_time = 0.65
		loop_time = 1.0
	if CharacterManager.game_mode == 1:
		end_time = 0.55
		loop_time = 0.8
	if CharacterManager.game_mode == 2:
		end_time = 0.45
		loop_time = 0.7
	if CharacterManager.game_mode >= 3:
		end_time = 0.0
		loop_time = 0.0

func _Setup() -> void :
	set_game_modes()
	play_animation("punch_prepare")

func _Update(delta: float) -> void :
	process_gravity(delta * 6.5)
	
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("punch_start")
		drill.play()
		step()
		next_attack_stage()
		
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("punch_loop")
		screenshake()
		damage_area.activate()
		next_attack_stage()
		
	elif attack_stage == 2 and timer > loop_time:
		damage_area.deactivate()
		play_animation("punch_end")
		next_attack_stage()
		
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("idle")
		next_attack_stage()
		
	elif attack_stage == 4 and timer > end_time:
		EndAbility()

func _Interrupt() -> void :
	emit_signal("stop")
	force_movement(0)
	damage_area.deactivate()

func step() -> void :
	tween.method("force_movement", 0.0, horizontal_velocity, 0.2)
	tween.add_method("force_movement", horizontal_velocity, 0.0, 0.45)
