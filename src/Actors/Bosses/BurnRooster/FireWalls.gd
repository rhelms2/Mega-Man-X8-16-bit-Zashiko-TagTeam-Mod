extends AttackAbility

export (PackedScene) var projectile
export (PackedScene) var fire_wall
export  var rage_duration: float = 1.5

onready var explosion: AudioStreamPlayer2D = $explosion
onready var land: AudioStreamPlayer2D = $land
onready var jump: AudioStreamPlayer2D = $jump
onready var rage: AudioStreamPlayer2D = $rage
onready var spit: Node2D = $spit

var desperation_damage_reduction: float = 0.5

signal ready_for_stun


func set_game_modes() -> void :
	desperation_damage_reduction = CharacterManager.boss_damage_reduction
	
func _Setup() -> void :
	set_game_modes()
	._Setup()
	character.emit_signal("damage_reduction", desperation_damage_reduction)
	rage.play()
	spit.handle_direction()

func _Update(delta: float) -> void :
	if attack_stage == 0:
		process_gravity(delta)
		if has_finished_last_animation():
			play_animation_once("rage_loop")
			screenshake()
			if timer > rage_duration:
				next_attack_stage()
	
	elif attack_stage == 1:
		play_animation_once("rage_end")
		next_attack_stage()
	
	elif attack_stage == 2 and has_finished_last_animation():
		play_animation_once("jump")
		jump.play()
		jump_to_room_center()
		next_attack_stage()
	
	elif attack_stage == 3:
		process_gravity(delta)
		pass
	
	elif attack_stage == 4:
		spit.handle_direction()
		land.play()
		play_animation_once("spit_prepare")
		emit_signal("ready_for_stun")
		next_attack_stage()
		
	elif attack_stage == 5 and has_finished_last_animation():
		play_animation_once("spit_loop")
		spit.activate()
		create_fire_wall()
		next_attack_stage()
		
	elif attack_stage == 6 and timer > 0.35:
		play_animation_once("spit_end")
		next_attack_stage()
		
	elif attack_stage == 7 and has_finished_last_animation():
		turn()
		spit.handle_direction()
		play_animation_once("spit_prepare")
		next_attack_stage()
		
	elif attack_stage == 8 and has_finished_last_animation():
		play_animation_once("spit_loop")
		spit.activate()
		create_fire_wall()
		next_attack_stage()
		
	elif attack_stage == 9 and timer > 0.35:
		play_animation_once("spit_end")
		next_attack_stage()
		
	elif attack_stage == 10 and has_finished_last_animation():
		turn()
		play_animation_once("idle")
		EndAbility()

func jump_to_room_center() -> void :
	var tween = new_tween()
	var sc = GameManager.camera.get_camera_screen_center()
	set_vertical_speed( - jump_velocity)
	tween.tween_property(character, "global_position:x", sc.x, 0.835).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(self, "next_attack_stage")

func create_fire_wall() -> void :
	var instance = fire_wall.instance()
	var boss_death: Node2D = $"../BossDeath"
	get_tree().current_scene.add_child(instance, true)
	instance.set_global_position(global_position)
	boss_death.connect("screen_flash", instance, "on_boss_death")
	instance.global_position = GameManager.camera.get_camera_screen_center()
	instance.global_position.y += 4
	instance.global_position.x += GameManager.camera.width / 2 * character.get_facing_direction() - 48 * character.get_facing_direction()
	screenshake()
	explosion.play()

func _Interrupt() -> void :
	._Interrupt()
	kill_tweens(tween_list)
	character.emit_signal("damage_reduction", 1.0)

func fire_projectile() -> void :
	var shot = instantiate_projectile(projectile)
	shot.global_position.y = global_position.y + 16
	shot.global_position.x += 32 * character.get_facing_direction()
	shot.set_horizontal_speed(700 * character.get_facing_direction())
