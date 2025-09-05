extends AttackAbility

onready var tween := TweenController.new(self,false)
onready var space: Node = $"../Space"
onready var idle: Node2D = $"../Idle"
onready var damage: Node2D = $"../Damage"
onready var flash: Sprite = $flash
onready var battle_song: AudioStreamPlayer = $"../Intro/BattleSong"
onready var desperation: AudioStreamPlayer = $Desperation
export var _holy_death : PackedScene
export var dialogue : Resource
var holy_death : Node2D
onready var damage_on_touch: Node2D = $"../DamageOnTouch"
onready var veil_manager: Node = $"../animatedSprite/VeilManager"
onready var reflector: Node2D = $"../DamageReflector"
onready var vfx: Node = $vfx
onready var windspark: Sprite = $windspark
onready var flash_2: Sprite = $flash2
onready var golden_particles: Particles2D = $golden_particles
onready var golden_particles_2: Particles2D = $golden_particles2
onready var vertical_flash: Sprite = $VerticalFlash

onready var explosions: Particles2D = $explosion_particles
onready var smoke: Particles2D = $smoke
onready var final_explosion: AudioStreamPlayer2D = $final_explosion
onready var light: Sprite = $background_light
onready var fullscreen_light: Sprite = $fullscreen_light
onready var break_vfx: AnimatedSprite = $break_vfx

const interval := 3.0
var first_death := true
signal screen_flash
signal true_death

func true_end():
	GlobalVariables.set("serenade_defeated", true)
	GameManager.start_cutscene()
	Tools.timer(0.25, "turn_player_towards_boss", self)
	smoke.emitting = true
	explosions.emitting = true
	final_explosion.play()
	desperation.fade_out(3)
	Tools.timer(2,"set_weak_light",self)
	golden_particles_2.emitting = false
	emit_signal("true_death")

func _ready() -> void :
	dialogue = CharacterManager._set_correct_dialogues("Secret2Defeated", dialogue)
	get_parent().listen("zero_health", self, "start_death")
	reset_shader()
	Event.listen("character_switch_end", self, "refresh_dialogue")
	
func refresh_dialogue() -> void :
	dialogue = CharacterManager._set_correct_dialogues("Secret2Defeated", dialogue)

func start_death():
	character.interrupt_all_moves()
	ExecuteOnce()
	
func reset_shader():
	set_light_alpha(0)
	set_light_color(0)

func _Setup():
	Event.emit_signal("first_secret2_death")
	play_animation("death")
	damage.deactivate()
	damage_on_touch.deactivate()
	reflector.deactivate()
	idle.deactivate()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	flash()
	blink()
	GameManager.pause(character.name + name)
	if first_death:
		Tools.timer(0.5, "unpause", self, null, true)
	else:
		break_vfx.visible = true
		break_vfx.playing = true
		Tools.timer(1.25, "unpause", self, null, true)
	
func unpause():
	GameManager.unpause(character.name + name)
	stop_blink()
	if first_death:
		first_death = false
		character.set_horizontal_speed(60 * -get_player_direction_relative())
		character.set_vertical_speed(-200)
		next_attack_stage()
	else:
		true_end()


func _Update(delta):
	if attack_stage == 1:
		process_gravity(delta)
		if character.is_on_floor() and timer > 0.1:
			play_animation("revive")
			turn_and_face_player()
			veil_manager._on_resetted()
			battle_song.fade_out(3)
			decay_speed_regardless_of_direction()
			next_attack_stage()
	
	elif attack_stage == 2 and timer > 3.6:
		play_animation("lotus_start")
		golden_particles.emitting = true
		screenshake()
		Tools.timer(1, "screenshake", self)
		Tools.timer(2, "screenshake", self)
		Tools.timer(3, "screenshake", self)
		vfx.activate()
		set_vertical_speed(-30)
		desperation.play()
		next_attack_stage()

	elif attack_stage == 3 and has_finished_last_animation():
		decay_vertical_speed_regardless_of_direction(4)
		play_animation("lotus")
		next_attack_stage()

	elif attack_stage == 4 and timer > 5:
		play_animation("unleash_start")
		vertical_flash.start()
		turn_and_face_player()
		damage_on_touch.activate()
		golden_particles.emitting = false
		golden_particles_2.emitting = true
		flash.start()
		Tools.timer(0.15,"start",flash_2)
		Tools.timer(0.35,"start",flash_2)
		reflector.reset()
		screenshake()
		start_holy_death()
		reset_health()
		vfx.deactivate()
		vfx.visible = false
		windspark.emit()
		next_attack_stage()

	elif attack_stage == 5 and has_finished_last_animation():
		play_animation("unleash")
		Tools.timer(1,"screenshake",self)
		Tools.timer(2,"screenshake",self)
		next_attack_stage()
	
	elif attack_stage == 6 and timer > 3:
		play_animation("teleport")
		damage.deactivate()
		reflector.deactivate()
		next_attack_stage()

	elif attack_stage == 7 and has_finished_last_animation():
		character.global_position.y -= 200
		next_attack_stage()

	elif attack_stage == 8 and timer > 1.5:
		idle.activate()
		EndAbility()
		pass
	
	
	
	elif attack_stage == 9 and timer > 1:
		start_dialog_or_go_to_attack_stage(11)

	elif attack_stage == 10:
		if seen_dialog():
			next_attack_stage()
			
	elif attack_stage == 11 and timer > 1:
		play_animation("teleport")
		next_attack_stage()
	
	elif attack_stage == 12 and timer > 2:
		GameManager.end_boss_death_cutscene()
		next_attack_stage()
		#character.destroy()
	#print(seen_dialog())

func start_holy_death():
	holy_death = _holy_death.instance()
	character.get_parent().add_child(holy_death)
	Tools.timer(0.1, "activate", holy_death)
	idle.connect("started", holy_death, "activate")
	
func end_holy_death():
	holy_death.deactivate()

func reset_health():
	Event.emit_signal("boss_health_hide")
	character.current_health = 160.0
	Event.emit_signal("boss_health_appear", character)
	character.emitted_zero_health = false

func flash():
	flash.start()

func blink():
	animatedSprite.material.set_shader_param("Flash", 1)
func stop_blink():
	animatedSprite.material.set_shader_param("Flash", 0)

func set_weak_light():
	print_debug("set weak light...")
	break_vfx.visible = false
	tween.create()
	tween.add_wait(8)
	tween.add_callback("end")

func end():
	smoke.emitting = false
	explosions.emitting = false
	play_animation("revive")
	emit_signal("screen_flash")
	turn_player_towards_boss()
	turn_and_face_player()
	Tools.timer_p(1,"go_to_attack_stage",self,9)
	#go_to_attack_stage(9)

func set_light_alpha(value: float):
	light.material.set_shader_param("Alpha", value)

func set_light_color(value: float):
	light.material.set_shader_param("Color", value)
	
func set_darken(value: float):
	animatedSprite.material.set_shader_param("Darken", value)


func start_dialog_or_go_to_attack_stage(skip_dialog_stage: = 0) -> void :
	if not seen_dialog():
		GameManager.start_dialog(dialogue)
		next_attack_stage()
	elif seen_dialog():
		go_to_attack_stage(skip_dialog_stage)

func seen_dialog() -> bool:
	return GameManager.was_dialogue_seen(dialogue)
