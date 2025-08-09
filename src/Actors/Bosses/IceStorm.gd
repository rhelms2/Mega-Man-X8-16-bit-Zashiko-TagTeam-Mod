extends AttackAbility

export var damage_reduction_during_desperation := 0.5

onready var shooter = $IceShooter
onready var particles = get_all_particles()
onready var prepare = $prepare
onready var storm = $storm
onready var scream = $scream

signal ready_for_stun


func _Setup():
	character.emit_signal("damage_reduction", damage_reduction_during_desperation)

func _Update(_delta):
	process_gravity(_delta)
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("desperate_loop")
		scream.play()
		next_attack_stage_on_next_frame()
		screenshake()
			
	elif attack_stage == 1 and timer > 0.5:
		next_attack_stage_on_next_frame()
			
	elif attack_stage == 2:
		play_animation_once("icestorm_prepare")
		if timer > 0.5 and timer < 0.51:
			prepare.play()
		if has_finished_last_animation():
			screenshake()
			shooter.activate()
			storm.play()
			next_attack_stage()
			toggle_emit(particles, true)
			emit_signal("ready_for_stun")
			
	elif attack_stage == 3:
		play_animation_once("icestorm_loop")
		screenshake()
		next_attack_stage()
	
	elif attack_stage == 4 and timer > 2.5:
		toggle_emit(particles, false)
		play_animation_once("icestorm_end")
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		EndAbility()

func _Interrupt():
	._Interrupt()
	character.emit_signal("damage_reduction", 1)
	for particle in particles:
		particle.emitting = false
	
