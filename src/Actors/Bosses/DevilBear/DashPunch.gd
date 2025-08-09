extends AttackAbility
onready var dash_sound: AudioStreamPlayer2D = $"../dash_sound"
onready var punch: AudioStreamPlayer2D = $"../punch"
onready var dash_particles: Particles2D = $"../dash_particles"
onready var prepare: Particles2D = $"../land"
onready var wallhit: Node2D = $wallhit
onready var hit: Particles2D = $"../animatedSprite/hit"
onready var wallpunch: AudioStreamPlayer2D = $"../wallpunch"
onready var wave: Sprite = $"../animatedSprite/wave"
onready var tween := TweenController.new(self,false)

func _Setup() -> void:
	turn_and_face_player()
	wallhit.handle_direction()

func _Update(delta) -> void:
	process_gravity(delta)
	if attack_stage == 0:
		play_animation_once("dash")
		dash_sound.play()
		prepare.emitting = true
		next_attack_stage()
	
	elif attack_stage == 1 and has_finished_last_animation():
		play_animation("dash_loop")
		next_attack_stage()
		
	elif attack_stage == 2 and timer > 0.35:
		force_movement(horizontal_velocity)
		next_attack_stage()
	
	elif attack_stage == 3 and has_finished_last_animation():
		play_animation("dash_loop")
		dash_particles.emitting = true
		next_attack_stage()
	
	elif attack_stage == 4 and facing_a_wall():
		create_wave()
		Tools.timer(0.05,"hit_wall",self)
		next_attack_stage()
	
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation_once("punch_end")
		next_attack_stage()
	
	elif attack_stage == 6 and timer > 0.25:
		EndAbility()

func hit_wall() -> void:
	wallhit.activate()
	wallpunch.play_rp()
	hit.restart()
	play_animation("punch_3")
	animatedSprite.frame = 3
	dash_particles.emitting = false
	prepare.restart()
	screenshake(0.9)

func create_wave() -> void:
	wave.visible = true
	wave.scale = Vector2(.5,.5)
	wave.modulate.a = 1
	tween.create()
	tween.set_parallel()
	tween.add_attribute("scale",Vector2(1,4.0),0.16,wave)
	tween.add_attribute("modulate:a",0.0,0.16,wave)

func _Interrupt() -> void:
	._Interrupt()
	dash_particles.emitting = false
