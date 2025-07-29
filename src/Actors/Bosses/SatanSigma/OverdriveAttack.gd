extends AttackAbility

onready var sigma_laser: Node2D = $"../animatedSprite/SigmaLaser"
onready var flash: Sprite = $flash
onready var raycast: RayCast2D = $"../animatedSprite/overdrive_raycast"
onready var shot: AudioStreamPlayer2D = $shot
onready var charge: AudioStreamPlayer2D = $charge
onready var particles: Particles2D = $particles
onready var charge_circle: Sprite = $charge_circle
onready var windspark: Sprite = $"../animatedSprite/windspark"

signal ready_for_stun

var used_laser = 0
var used_laser_dir = 0
onready var boss_ai = get_parent().get_node("BossAI")

var desperation_damage_reduction = 0.5

func set_game_modes():
	desperation_damage_reduction = CharacterManager.boss_damage_reduction

func _Setup() -> void :
	set_game_modes()
	character.emit_signal("damage_reduction", desperation_damage_reduction)
	if used_laser == 0:
		turn_and_face_player()
	else:
		set_direction( - used_laser_dir)
	raycast.enabled = true
	play_animation("cannon_prepare")
	particles.emitting = true
	charge_circle.activate()
	screenshake(0.75)
	charge.play()
	if used_laser_dir == 0:
		used_laser_dir = get_facing_direction()

func _Update(delta: float) -> void :
	if attack_stage == 0 and has_finished_last_animation():
		play_animation("cannon_prepare_loop")
		next_attack_stage()
		
	elif attack_stage == 1 and timer > 1.2:
		play_animation("cannon_start")
		screenshake(0.75)
		
		charge_circle.deactivate()
		shot.play()
		particles.emitting = false
		next_attack_stage()
		
	if attack_stage == 2 and has_finished_last_animation():
		play_animation("cannon_loop")
		screenshake()
		Event.emit_signal("sigma_desperation", get_facing_direction())
		emit_signal("ready_for_stun")
		flash.start()
		sigma_laser.activate()
		tween_speed( - abs(get_distance_to_back_wall()), 0, 2.4)
		next_attack_stage()
		Tools.timer(0.7, "start", flash)
		Tools.timer(0.9, "start", flash)
		Tools.timer(1.7, "start", flash)
		windspark.emit()
		
	elif attack_stage == 3:
		screenshake(0.25)
		if timer > 2.4:
			play_animation("cannon_end_loop")
			sigma_laser.deactivate()
			next_attack_stage()
		
	elif attack_stage == 4 and timer > 1:
		play_animation("cannon_end")
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		if used_laser == 0:
			used_laser = 1
		else:
			boss_ai.desperation_chance = 0
		EndAbility()
		
func _Interrupt():
	character.emit_signal("damage_reduction", 1.0)
	._Interrupt()
	sigma_laser.deactivate()
	particles.emitting = false
	charge_circle.deactivate()
	
func get_distance_to_back_wall() -> float:
	return (global_position.x - raycast.get_collision_point().x) / 2
