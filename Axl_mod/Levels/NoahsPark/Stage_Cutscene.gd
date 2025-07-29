extends Node2D

onready var door: AnimatedSprite = $DamagedCraft / Door
onready var craft: AnimatedSprite = $DamagedCraft

onready var tween: = TweenController.new(self, false)
onready var door_smoke: Particles2D = $DamagedCraft / Door / smoke
onready var door_smoke_2: Particles2D = $DamagedCraft / Door / smoke2
onready var light: Sprite = $Visuals / light

var dialogbox: Label
onready var doorhit: AudioStreamPlayer2D = $DamagedCraft / Door / doorhit
onready var explode: AudioStreamPlayer2D = $DamagedCraft / Door / explode
onready var screencover: Sprite = $screencover
onready var explosion_particles: Particles2D = $explosion_particles
onready var background_cover: Sprite = $background_cover

onready var visuals: Node2D = $Visuals
onready var firenoise: AudioStreamPlayer2D = $Visuals / firenoise
onready var craft_explosion: Particles2D = $craft_explosion
onready var remains_particles: Particles2D = $remains_particles
onready var explosion_sfx: AudioStreamPlayer2D = $explosion_particles / explosion_sfx
onready var skip_screencover: Sprite = $skip_screencover
onready var wall_particles: Particles2D = $background_cover / remains_particles
onready var flash: Sprite = $DamagedCraft / flash

var executing: = false

func _ready() -> void :
	Event.connect("noahspark_cutscene_start", self, "start")
	Event.connect("kingcrab_crash", self, "explode_craft")
	Event.emit_signal("disable_victory_ending")
	get_rid_of_everything_uneeded()
	set_physics_process(false)
	

func start():
	dialogbox = GameManager.dialog_box
	Event.emit_signal("noahspark_cutscene_end")


var skip_timer: = 0.0

func _physics_process(delta: float) -> void :
	if Configurations.exists("SkipDialog"):
		if Configurations.get("SkipDialog") == false:
			set_physics_process(false)
			return

func get_rid_of_everything_uneeded():
	tween.reset()
	
	
	explosion_particles.emitting = false
	door.queue_free()
	screencover.queue_free()
	background_cover.queue_free()
	
	executing = false

func end_skip():
	Event.emit_signal("noahspark_cutscene_end")

func quick_fadeout():
	skip_screencover.visible = true
	skip_screencover.modulate.a = 1.0

func quick_fadein():
	skip_screencover.visible = true
	skip_screencover.modulate.a = 1.0
	tween.attribute("modulate:a", 0.0, 0.4, skip_screencover)

func stop_all_music_and_sounds():
	firenoise.stop()
	explosion_sfx.stop()

func explode_everything():
	if not executing:
		return
	Event.emit_signal("screenshake", 2.0)
	flash.start()
	explosion_particles.emitting = true
	wall_particles.emitting = true
	screencover.visible = true
	screencover.modulate.a = 0.0
	tween.attribute("modulate:a", 1, 1.0, screencover)
	tween.attribute("volume_db", - 80, 4.0, firenoise)
	tween.method("set_radius", 26, 120, 1)
	Tools.timer(4.0, "stop_explosions", self)
	Tools.timer(5.0, "fade_flash", self)

func stop_explosions():
	if not executing:
		return
	background_cover.visible = false
	visuals.visible = false
	craft.modulate = Color.darkgray
	Tools.timer_p(1.0, "set_deferred", explosion_particles, ["emitting", false])
	
onready var dust: Particles2D = $dust

func fade_flash():
	if not executing:
		return
	dust.emitting = true
	tween.attribute("modulate:a", 0, 4.0, screencover)
	Event.emit_signal("screenshake", 2.0)

func finish_cutscene():
	if not executing:
		return
	executing = false
	set_physics_process(false)
	Event.emit_signal("noahspark_cutscene_end")
	
func explode_craft():
	flash.start()
	Tools.timer(0.1, "hide_craft", self)
	craft_explosion.emitting = true
	remains_particles.emitting = true
	tween.reset()
	visuals.visible = false

func hide_craft():
	craft.visible = false

func reset():
	tween.reset()
	door.position = Vector2.ZERO
	door.rotation_degrees = 0.0
	door.self_modulate.a = 1.0
	blink_light_forever()

func hide_door():
	door.self_modulate.a = 0

func blink_door(value):
	blink(door, value)

func blink_light_forever():
	tween.method("blink_light", 0, 10, 1.0)
	tween.add_callback("blink_light_forever")

func blink_light(value):
	light.self_modulate.a = inverse_lerp( - 1, 1, sin(value)) * 0.3 + 0.7

func blink(object, time: float):
	object.self_modulate.a = inverse_lerp( - 1, 1, sin(time))
	
func set_radius(value: float):
	explosion_particles.process_material.emission_sphere_radius = value
	
