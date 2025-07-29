extends Node2D

const interval: float = 3.0

onready var explosions: Particles2D = $explosion_particles
onready var smoke: Particles2D = $smoke
onready var audio: AudioStreamPlayer2D = $final_explosion
onready var animation := AnimationController.new($"../animatedSprite")
onready var character: Panda = $".."
onready var tween := TweenController.new(self,false)
onready var space: Node = $"../Space"
onready var light: Sprite = $background_light
onready var fullscreen_light: Sprite = $fullscreen_light
onready var idle: Node2D = $"../Idle"
onready var feather_particles: Particles2D = $"../animatedSprite/feather_particles"
onready var back_wings: AnimatedSprite = $"../backWings"
onready var front_wings: AnimatedSprite = $"../frontWings"
onready var damage: Node2D = $"../Damage"
onready var windspark: Sprite = $windspark
onready var flash: Sprite = $flash

signal screen_flash


func _ready() -> void:
	get_parent().listen("zero_health",self,"_Setup")
	reset_shader()

func reset_shader():
	set_light_alpha(0)
	set_light_color(0)

func _Setup():
	idle.deactivate()
	damage.max_flash_time = 15
	character.interrupt_all_moves()
	character.set_horizontal_speed(0)
	character.set_vertical_speed(0)
	character.emit_signal("death")
	back_wings.material = animation.animatedSprite.material
	front_wings.material = animation.animatedSprite.material
	flash()
	Event.emit_signal("enemy_kill","SeraphLumine")
	Event.emit_signal("end_cutscene_start")
	Event.emit_signal("beat_seraph_lumine")
	GameManager.pause(character.name + name)
	GameManager.start_end_cutscene()
	Tools.timer(1.25,"unpause",self,null,true)
	
	GlobalVariables.set("seraph_lumine_defeated",true)
	GameManager.current_armor = GameManager.player.current_armor
	IGT.should_run_rta = false
	if CharacterManager.game_mode == 1:
		CharacterManager.beaten_hard = true
	if CharacterManager.game_mode == 2:
		CharacterManager.beaten_insanity = true
	if CharacterManager.game_mode >= 3:
		CharacterManager.beaten_ninjagaiden = true
	CharacterManager._save()

func unpause() -> void :
	GameManager.unpause(character.name + name)
	animation.play("death_loop")
	activate()

func activate():
	screnshake()
	smoke.emitting = true
	explosions.emitting = true
	audio.play()
	go_to_center()
	Tools.timer(2,"set_weak_light",self)
	Tools.timer(.1,"blink",self)
	tween.method("set_radius",70.0,140.0,10.0)
	queue_flashes()

func queue_flashes():
	Tools.timer(0.25,"flash",self)
	Tools.timer(1.25,"flash",self)
	Tools.timer(2,"flash",self)
	Tools.timer(2.3,"flash",self)
	Tools.timer(3,"flash",self)
	Tools.timer(4,"flash",self)
	Tools.timer(4.2,"flash",self)
	Tools.timer(4.4,"flash",self)
	Tools.timer(4.8,"flash",self)
	Tools.timer(5,"flash",self)
	Tools.timer(6,"flash",self)
	Tools.timer(7,"flash",self)

func flash():
	flash.start()

func blink():
	animation.animatedSprite.material.set_shader_param("Flash", 1)
	windspark.emit()

func set_weak_light() -> void :
	tween.method("set_darken", 1, 0.1, 8)
	feather_particles.emitting = false
	tween.method("set_light_alpha", 0, 0.33, interval)
	tween.add_callback("set_mid_light")

func set_mid_light():
	windspark.emit()
	tween.method("set_light_alpha", 0.33, 0.66, interval)
	tween.method("set_light_color", 0, 1.0, interval)
	tween.add_callback("set_final_light")

func set_final_light() -> void :
	windspark.emit()
	tween.method("set_light_alpha", 0.66, 1, interval)
	tween.method("set_light_color", 1.0, 2.0, 2.0)
	Tools.timer(1.25, "set_fullscreen_light", self)
	Tools.timer(1.0, "play_death_end", self)

func play_death_end():
	animation.play("death_end")

func set_fullscreen_light():
	fullscreen_light.visible = true
	windspark.emit()
	tween.attribute("modulate:a",1.0,1.5,fullscreen_light)
	tween.add_callback("emit_signal",self,["screen_flash"])
	tween.add_wait(3.0)
	tween.add_callback("end")

func end():
	GameManager.end_game()

func set_light_alpha(value : float):
	light.material.set_shader_param("Alpha",value)

func set_light_color(value : float):
	light.material.set_shader_param("Color",value)
	
func set_darken(value : float):
	animation.animatedSprite.material.set_shader_param("Darken",value)

func set_radius(value:float):
	explosions.process_material.emission_sphere_radius = value
	#explosions.amount = value - 10


func go_to_center() -> void:
	var center = GameManager.camera.get_camera_screen_center() + Vector2(0,-42)
	var time_to_return = 8.0
	#turn_towards_point(center)
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	tween.add_attribute("global_position",center,time_to_return,character)

func turn_towards_point(point_global_position) -> void:
	if point_global_position.x > character.global_position.x:
		character.set_direction(1)
	else:
		character.set_direction(-1)

func screnshake():
	Event.emit_signal("screenshake",2)
	Tools.timer(1,"screnshake",self)
