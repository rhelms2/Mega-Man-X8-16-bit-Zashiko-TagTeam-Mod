extends AttackAbility
onready var stun: Node2D = $"../BossStun"
onready var eye: Node2D = $"../animatedSprite/Eye"
onready var eye2: Node2D = $"../animatedSprite/Eye2"
onready var charge: AudioStreamPlayer2D = $charge
onready var beam: AudioStreamPlayer2D = $beam
onready var flash: Sprite = $flash
onready var copy_dash: Node2D = $"../CopyDash"

var desperation_damage_reduction = 0.5

func set_game_modes():
	desperation_damage_reduction = CharacterManager.boss_damage_reduction
	
func _Setup():
	set_game_modes()
	character.emit_signal("damage_reduction", desperation_damage_reduction)
	turn_and_face_player()
	copy_dash.deactivate()
	stun.deactivate()

func _Update(_delta: float) -> void :
	process_gravity(_delta)

	if attack_stage == 0:
		play_animation("eye_start")
		charge.play()
		next_attack_stage()

	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("eye_loop")
		beam.play()
		eye.start_eyes()
		eye2.start_eyes()
		next_attack_stage()

	elif attack_stage == 2 and timer > 1:
		Event.emit_signal("copy_sigma_desperation")
		next_attack_stage()
	
	elif attack_stage == 3 and timer > 1:
		Event.emit_signal("copy_sigma_flash")
		flash.start()
		eye.end()
		eye2.end()
		beam.stop()
		next_attack_stage()
	
	elif attack_stage == 4 and timer > 1:
		play_animation("eye_end")
		next_attack_stage()

	elif attack_stage == 5 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	eye.end()
	eye2.end()
	beam.stop()
	stun.activate()
	character.emit_signal("damage_reduction", 1.0)
