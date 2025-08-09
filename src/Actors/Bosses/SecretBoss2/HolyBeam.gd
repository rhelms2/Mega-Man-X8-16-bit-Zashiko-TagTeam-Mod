extends AttackAbility

var diag_attack := false
onready var laser: Node2D = $"../animatedSprite/SigmaLaser"
onready var diag_laser: Node2D = $"../animatedSprite/SigmaLaser2"
onready var shot: AudioStreamPlayer2D = $shot
onready var flash: Sprite = $flash

func _Setup():
	turn_and_face_player()
	if GameManager.get_player_position().y < global_position.y - 64:
		diag_attack = true
	else:
		diag_attack = false

func _Update(_delta):
	if attack_stage == 0:
		play_animation("attack_prepare")
		next_attack_stage()
		
	elif attack_stage == 1 and timer > 1.0:
		play_animation("attack_start")
		screenshake()
		#Tools.timer(.5,"screenshake",self)
		Tools.timer(1.2,"screenshake",self)
		shot.play()
		activate_laser()
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation("attack_loop")
		next_attack_stage()
		
	elif attack_stage == 3 and timer > 1.6:
		play_animation("attack_end")
		deactivate_laser()
		next_attack_stage()
		
	elif attack_stage == 4 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	shot.stop()
	deactivate_laser()
	diag_laser.visible = false
	laser.visible = false

func activate_laser():
	if diag_attack:
		diag_laser.activate()
		return
	laser.activate()

func deactivate_laser():
	if diag_attack:
		diag_laser.deactivate()
		return
	laser.deactivate()

func play_animation(anim_name : String) -> void:
	var diag_prefix := "diag"
	if diag_attack:
		.play_animation(diag_prefix + anim_name)
	else:
		.play_animation(anim_name)

func screenshake(value := 2.0):
	if executing:
		flash.start()
		.screenshake(value)
	pass
